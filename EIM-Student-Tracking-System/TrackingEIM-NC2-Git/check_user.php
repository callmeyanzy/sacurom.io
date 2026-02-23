<?php
require_once __DIR__ . '/config/database.php';

$pdo = Database::getConnection();
$stmt = $pdo->query("SELECT id, email, password, role FROM users WHERE email = 'admin@eim.local'");
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    echo "User found: " . $user['email'] . "\n";
    echo "Password hash: " . substr($user['password'], 0, 20) . "...\n";
    echo "Verify 'admin123': " . (password_verify('admin123', $user['password']) ? 'YES' : 'NO') . "\n";
    echo "Verify 'password': " . (password_verify('password', $user['password']) ? 'YES' : 'NO') . "\n";
} else {
    echo "User not found!\n";
    echo "Total users in database: ";
    $count = $pdo->query("SELECT COUNT(*) FROM users")->fetchColumn();
    echo $count . "\n";
}
