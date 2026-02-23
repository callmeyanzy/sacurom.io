<?php
// models/User.php
require_once __DIR__ . '/../config/database.php';

class User
{
    public static function findByEmail(string $email)
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('SELECT id, name, email, password, role FROM users WHERE email = :email LIMIT 1');
        $stmt->execute([':email' => $email]);
        return $stmt->fetch();
    }

    public static function find(int $id)
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('SELECT id, name, email, role, created_at FROM users WHERE id = :id');
        $stmt->execute([':id' => $id]);
        return $stmt->fetch();
    }

    public static function all()
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->query('SELECT id, name, email, role, created_at FROM users ORDER BY created_at DESC');
        return $stmt->fetchAll();
    }

    public static function create($name, $email, $password, $role = 'student')
    {
        $pdo = Database::getConnection();
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare('INSERT INTO users (name, email, password, role) VALUES (:name, :email, :password, :role)');
        return $stmt->execute([':name' => $name, ':email' => $email, ':password' => $hash, ':role' => $role]);
    }

    public static function createOAuthUser($name, $email, $oauthProvider, $oauthId, $avatarUrl = null, $role = 'student')
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('INSERT INTO users (name, email, oauth_provider, oauth_id, avatar_url, role) VALUES (:name, :email, :provider, :oauth_id, :avatar, :role)');
        return $stmt->execute([
            ':name' => $name,
            ':email' => $email,
            ':provider' => $oauthProvider,
            ':oauth_id' => $oauthId,
            ':avatar' => $avatarUrl,
            ':role' => $role
        ]);
    }

    public static function findByOAuth($provider, $oauthId)
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('SELECT * FROM users WHERE oauth_provider = :provider AND oauth_id = :oauth_id LIMIT 1');
        $stmt->execute([':provider' => $provider, ':oauth_id' => $oauthId]);
        return $stmt->fetch();
    }

    public static function update($id, $name, $email, $role)
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('UPDATE users SET name = :name, email = :email, role = :role WHERE id = :id');
        return $stmt->execute([':name' => $name, ':email' => $email, ':role' => $role, ':id' => $id]);
    }

    public static function delete($id)
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare('DELETE FROM users WHERE id = :id');
        return $stmt->execute([':id' => $id]);
    }

    public static function updatePassword($id, $newPassword)
    {
        $pdo = Database::getConnection();
        $hash = password_hash($newPassword, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare('UPDATE users SET password = :password WHERE id = :id');
        return $stmt->execute([':password' => $hash, ':id' => $id]);
    }
}
