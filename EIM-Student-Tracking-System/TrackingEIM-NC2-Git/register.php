<?php
require_once __DIR__ . '/bootstrap.php';

// If already logged in, redirect to dashboard
if (!empty($_SESSION['user'])) {
    header('Location: dashboard.php');
    exit;
}

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // CSRF check
    $token = $_POST['csrf_token'] ?? '';
    if (!csrf_check($token)) {
        $error = 'Invalid form token. Please try again.';
    } else {
        $name = trim($_POST['name'] ?? '');
        $email = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';
        $confirmPassword = $_POST['confirm_password'] ?? '';

        // Validation
        if ($name === '' || $email === '' || $password === '') {
            $error = 'Please fill in all required fields.';
        } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $error = 'Please enter a valid email address.';
        } elseif (strlen($password) < 6) {
            $error = 'Password must be at least 6 characters long.';
        } elseif ($password !== $confirmPassword) {
            $error = 'Passwords do not match.';
        } else {
            // Check if email already exists
            $existingUser = User::findByEmail($email);
            if ($existingUser) {
                $error = 'An account with this email already exists.';
            } else {
                // Create new user
                if (User::create($name, $email, $password, 'student')) {
                    // Get the newly created user
                    $newUser = User::findByEmail($email);
                                    
                    // Create a student record for this user
                    require_once __DIR__ . '/models/Student.php';
                    require_once __DIR__ . '/models/StudentCompetency.php';
                                    
                    Student::create($name, $email, null, date('Y-m-d'));
                    $studentId = Database::getConnection()->lastInsertId();
                                    
                    // Link student to user
                    $pdo = Database::getConnection();
                    $stmt = $pdo->prepare('UPDATE students SET user_id = :user_id WHERE id = :id');
                    $stmt->execute([':user_id' => $newUser['id'], ':id' => $studentId]);
                                    
                    // Initialize competencies for the new student
                    StudentCompetency::initializeStudentCompetencies($studentId);
                                            
                    // Auto-login the user
                    $_SESSION['user'] = [
                        'id' => $newUser['id'],
                        'name' => $newUser['name'],
                        'email' => $newUser['email'],
                        'role' => $newUser['role'],
                        'avatar_url' => $newUser['avatar_url'] ?? null
                    ];
                    session_regenerate_id(true);
                                            
                    // Redirect to dashboard
                    header('Location: dashboard.php');
                    exit;
                } else {
                    $error = 'Registration failed. Please try again.';
                }
            }
        }
    }
}

require __DIR__ . '/views/layouts/header.php';
?>

<div class="row justify-content-center">
    <div class="col-md-5">
        <div class="card shadow">
            <div class="card-header bg-success text-white text-center py-4">
                <h4 class="mb-0"><i class="fas fa-user-plus me-2"></i>Create Account</h4>
                <small>Register for EIM NC II Tracker</small>
            </div>
            <div class="card-body p-4">
                <?php if (!empty($error)): ?>
                    <div class="alert alert-danger"><?php echo e($error); ?></div>
                <?php endif; ?>
                
                <?php if (!empty($success)): ?>
                    <div class="alert alert-success"><?php echo e($success); ?></div>
                <?php endif; ?>
                
                <form method="post">
                    <input type="hidden" name="csrf_token" value="<?php echo e(csrf_token()); ?>">
                    
                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-user me-1"></i>Full Name</label>
                        <input type="text" class="form-control" name="name" required autofocus 
                               value="<?php echo e($_POST['name'] ?? ''); ?>">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-envelope me-1"></i>Email</label>
                        <input type="email" class="form-control" name="email" required
                               value="<?php echo e($_POST['email'] ?? ''); ?>">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-lock me-1"></i>Password</label>
                        <input type="password" class="form-control" name="password" required minlength="6">
                        <small class="text-muted">At least 6 characters</small>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label"><i class="fas fa-lock me-1"></i>Confirm Password</label>
                        <input type="password" class="form-control" name="confirm_password" required>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-user-plus me-1"></i>Register
                        </button>
                    </div>
                </form>
                
                <hr class="my-4">
                
                <!-- Google Sign Up Button -->
                <div class="d-grid">
                    <a href="google_auth.php?action=register" class="btn btn-outline-danger">
                        <i class="fab fa-google me-2"></i>Sign up with Google
                    </a>
                </div>
            </div>
            <div class="card-footer text-center">
                <small>Already have an account? <a href="login.php">Login here</a></small>
            </div>
        </div>
    </div>
</div>

<?php require __DIR__ . '/views/layouts/footer.php'; ?>
