<?php
// controllers/auth.php - Authentication actions
require_once __DIR__ . '/../bootstrap.php';

$action = $_GET['action'] ?? '';

if ($action === 'logout') {
    // Clear session
    $_SESSION = [];
    
    // Clear cookie
    if (ini_get('session.use_cookies')) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
            $params['path'], $params['domain'], $params['secure'], $params['httponly']
        );
    }
    
    session_destroy();
    header('Location: /login.php');
    exit;
}

// Default redirect
header('Location: /login.php');
exit;
