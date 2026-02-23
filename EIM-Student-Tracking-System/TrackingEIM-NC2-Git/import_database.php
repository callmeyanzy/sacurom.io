<?php
// Database import script

$host = '127.0.0.1';
$dbName = 'eim_progress_db';
$username = 'root';
$password = '';

// SQL file to import
$sqlFile = __DIR__ . '/sql/create_tables.sql';

try {
    // Connect without database to create it
    $pdo = new PDO("mysql:host=$host", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Create database if not exists
    $pdo->exec("CREATE DATABASE IF NOT EXISTS $dbName CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    echo "Database '$dbName' created or already exists.\n";
    
    // Select the database
    $pdo->exec("USE $dbName");
    
    // Read SQL file
    $sql = file_get_contents($sqlFile);
    if ($sql === false) {
        die("Error: Could not read SQL file: $sqlFile\n");
    }
    
    // Split SQL file into individual statements
    $statements = array_filter(array_map('trim', explode(';', $sql)));
    
    $successCount = 0;
    $errorCount = 0;
    
    foreach ($statements as $statement) {
        if (!empty($statement)) {
            try {
                $pdo->exec($statement);
                $successCount++;
            } catch (PDOException $e) {
                // Ignore "already exists" errors
                if (strpos($e->getMessage(), 'already exists') === false) {
                    echo "Error executing statement: " . $e->getMessage() . "\n";
                    $errorCount++;
                } else {
                    $successCount++;
                }
            }
        }
    }
    
    echo "\n====================================\n";
    echo "Database import completed!\n";
    echo "Successful statements: $successCount\n";
    if ($errorCount > 0) {
        echo "Errors: $errorCount\n";
    }
    echo "====================================\n";
    
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage() . "\n");
}
