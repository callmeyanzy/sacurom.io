<?php
require_once __DIR__ . '/config/database.php';

$pdo = Database::getConnection();

// Reset admin password to 'admin123'
$hash = password_hash('admin123', PASSWORD_DEFAULT);
$stmt = $pdo->prepare("UPDATE users SET password = :password WHERE email = 'admin@eim.local'");
$stmt->execute([':password' => $hash]);

if ($stmt->rowCount() > 0) {
    echo "Admin password reset successfully!\n";
    echo "Email: admin@eim.local\n";
    echo "Password: admin123\n";
} else {
    echo "Admin user not found. Creating new admin...\n";
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password, role) VALUES (:name, :email, :password, :role)");
    $stmt->execute([
        ':name' => 'Administrator',
        ':email' => 'admin@eim.local',
        ':password' => $hash,
        ':role' => 'admin'
    ]);
    echo "Admin user created!\n";
    echo "Email: admin@eim.local\n";
    echo "Password: admin123\n";
}
