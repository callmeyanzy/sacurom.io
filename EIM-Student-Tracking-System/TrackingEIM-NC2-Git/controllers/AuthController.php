<?php
// controllers/AuthController.php
require_once __DIR__ . '/../config/database.php';

class AuthController
{
    public static function login($email, $password)
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('SELECT id, name, email, password, role FROM users WHERE email = :email LIMIT 1');
        $stmt->execute([':email' => $email]);
        $user = $stmt->fetch();

        if ($user && password_verify($password, $user['password'])) {
            $_SESSION['user'] = [
                'id' => $user['id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'role' => $user['role']
            ];
            session_regenerate_id(true);
            return true;
        }
        return false;
    }

    public static function logout()
    {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $params['path'], $params['domain'], $params['secure'], $params['httponly']
            );
        }
        session_destroy();
    }

    public static function isLoggedIn()
    {
        return !empty($_SESSION['user']);
    }

    public static function isAdmin()
    {
        return !empty($_SESSION['user']) && $_SESSION['user']['role'] === 'admin';
    }

    public static function getCurrentUser()
    {
        return $_SESSION['user'] ?? null;
    }
}
