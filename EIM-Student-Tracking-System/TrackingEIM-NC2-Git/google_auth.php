<?php
require_once __DIR__ . '/bootstrap.php';

// Google OAuth Configuration
// NOTE: You need to set up Google OAuth credentials at https://console.cloud.google.com/
// and replace these values with your actual Client ID and Client Secret

define('GOOGLE_CLIENT_ID', $_ENV['GOOGLE_CLIENT_ID'] ?? 'YOUR_GOOGLE_CLIENT_ID');
define('GOOGLE_CLIENT_SECRET', $_ENV['GOOGLE_CLIENT_SECRET'] ?? 'YOUR_GOOGLE_CLIENT_SECRET');
define('GOOGLE_REDIRECT_URI', 'http://' . $_SERVER['HTTP_HOST'] . '/google_auth.php');

$action = $_GET['action'] ?? 'login';

// Step 1: Redirect to Google OAuth
if (!isset($_GET['code'])) {
    $state = bin2hex(random_bytes(16));
    $_SESSION['google_oauth_state'] = $state;
    $_SESSION['google_oauth_action'] = $action;
    
    $params = [
        'client_id' => GOOGLE_CLIENT_ID,
        'redirect_uri' => GOOGLE_REDIRECT_URI,
        'response_type' => 'code',
        'scope' => 'openid email profile',
        'state' => $state,
        'prompt' => 'select_account'
    ];
    
    $authUrl = 'https://accounts.google.com/o/oauth2/v2/auth?' . http_build_query($params);
    header('Location: ' . $authUrl);
    exit;
}

// Step 2: Handle callback from Google
if (isset($_GET['code'])) {
    // Verify state to prevent CSRF
    if (!isset($_GET['state']) || $_GET['state'] !== ($_SESSION['google_oauth_state'] ?? '')) {
        die('Invalid state parameter. Possible CSRF attack.');
    }
    
    // Exchange code for access token
    $tokenUrl = 'https://oauth2.googleapis.com/token';
    $tokenData = [
        'code' => $_GET['code'],
        'client_id' => GOOGLE_CLIENT_ID,
        'client_secret' => GOOGLE_CLIENT_SECRET,
        'redirect_uri' => GOOGLE_REDIRECT_URI,
        'grant_type' => 'authorization_code'
    ];
    
    $ch = curl_init($tokenUrl);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($tokenData));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $tokenResponse = curl_exec($ch);
    curl_close($ch);
    
    $tokenInfo = json_decode($tokenResponse, true);
    
    if (!isset($tokenInfo['access_token'])) {
        die('Failed to get access token from Google.');
    }
    
    // Get user info from Google
    $userInfoUrl = 'https://openidconnect.googleapis.com/v1/userinfo';
    $ch = curl_init($userInfoUrl);
    curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer ' . $tokenInfo['access_token']]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $userInfoResponse = curl_exec($ch);
    curl_close($ch);
    
    $googleUser = json_decode($userInfoResponse, true);
    
    if (!isset($googleUser['email'])) {
        die('Failed to get user info from Google.');
    }
    
    // Check if user already exists
    $pdo = Database::getConnection();
    $stmt = $pdo->prepare('SELECT * FROM users WHERE email = :email OR (oauth_provider = :provider AND oauth_id = :oauth_id)');
    $stmt->execute([
        ':email' => $googleUser['email'],
        ':provider' => 'google',
        ':oauth_id' => $googleUser['sub']
    ]);
    $existingUser = $stmt->fetch();
    
    if ($existingUser) {
        // User exists - log them in
        $_SESSION['user'] = [
            'id' => $existingUser['id'],
            'name' => $existingUser['name'],
            'email' => $existingUser['email'],
            'role' => $existingUser['role'],
            'avatar_url' => $existingUser['avatar_url']
        ];
        session_regenerate_id(true);
        header('Location: dashboard.php');
        exit;
    } else {
        // New user - register them
        $action = $_SESSION['google_oauth_action'] ?? 'login';
        
        if ($action === 'register' || $action === 'login') {
            // Create new user
            $stmt = $pdo->prepare('INSERT INTO users (name, email, oauth_provider, oauth_id, avatar_url, role) VALUES (:name, :email, :provider, :oauth_id, :avatar, :role)');
            $stmt->execute([
                ':name' => $googleUser['name'] ?? $googleUser['email'],
                ':email' => $googleUser['email'],
                ':provider' => 'google',
                ':oauth_id' => $googleUser['sub'],
                ':avatar' => $googleUser['picture'] ?? null,
                ':role' => 'student'
            ]);
            
            $userId = $pdo->lastInsertId();
            
            // Create a student record for this user
            require_once __DIR__ . '/models/Student.php';
            require_once __DIR__ . '/models/StudentCompetency.php';
            
            Student::create($googleUser['name'] ?? $googleUser['email'], $googleUser['email'], null, date('Y-m-d'));
            $studentId = $pdo->lastInsertId();
            
            // Link student to user
            $stmt = $pdo->prepare('UPDATE students SET user_id = :user_id WHERE id = :id');
            $stmt->execute([':user_id' => $userId, ':id' => $studentId]);
            
            // Initialize competencies for the new student
            StudentCompetency::initializeStudentCompetencies($studentId);
            
            $_SESSION['user'] = [
                'id' => $userId,
                'name' => $googleUser['name'] ?? $googleUser['email'],
                'email' => $googleUser['email'],
                'role' => 'student',
                'avatar_url' => $googleUser['picture'] ?? null
            ];
            session_regenerate_id(true);
            header('Location: dashboard.php');
            exit;
        }
    }
}

// If we get here, something went wrong
header('Location: login.php?error=google_auth_failed');
exit;
