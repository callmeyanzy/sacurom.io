<?php
require_once 'config/database.php';

echo "=== DATABASE STATUS CHECK ===\n\n";

try {
    $pdo = Database::getConnection();
    
    // Check tables
    $tables = $pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
    echo "Tables in database:\n";
    foreach ($tables as $table) {
        $count = $pdo->query("SELECT COUNT(*) FROM $table")->fetchColumn();
        echo "  - $table: $count records\n";
    }
    
    echo "\n--- USERS ---\n";
    $users = $pdo->query('SELECT id, name, email, role FROM users')->fetchAll(PDO::FETCH_ASSOC);
    foreach ($users as $user) {
        echo "  {$user['id']}: {$user['name']} ({$user['email']}) - {$user['role']}\n";
    }
    
    echo "\n--- BATCHES ---\n";
    $batches = $pdo->query('SELECT id, name FROM batches')->fetchAll(PDO::FETCH_ASSOC);
    foreach ($batches as $batch) {
        echo "  {$batch['id']}: {$batch['name']}\n";
    }
    
    echo "\n--- STUDENTS ---\n";
    $students = $pdo->query('SELECT id, name, email, batch_id, status FROM students')->fetchAll(PDO::FETCH_ASSOC);
    foreach ($students as $student) {
        $batch = $student['batch_id'] ? 'Batch #' . $student['batch_id'] : 'No batch';
        echo "  {$student['id']}: {$student['name']} ({$student['email']}) - $batch - {$student['status']}\n";
    }
    
    echo "\n--- COMPETENCIES ---\n";
    $comps = $pdo->query('SELECT id, code, title FROM competencies')->fetchAll(PDO::FETCH_ASSOC);
    foreach ($comps as $comp) {
        echo "  {$comp['id']}: {$comp['code']} - {$comp['title']}\n";
    }
    
    echo "\n=== CHECK COMPLETE ===\n";
    
} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
}
