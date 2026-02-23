<?php
require_once __DIR__ . '/config/database.php';

$pdo = Database::getConnection();

try {
    // Add oauth columns
    $pdo->exec('ALTER TABLE users ADD COLUMN IF NOT EXISTS oauth_provider VARCHAR(20) NULL AFTER role');
    echo "Added oauth_provider column\n";
    
    $pdo->exec('ALTER TABLE users ADD COLUMN IF NOT EXISTS oauth_id VARCHAR(255) NULL AFTER oauth_provider');
    echo "Added oauth_id column\n";
    
    $pdo->exec('ALTER TABLE users ADD COLUMN IF NOT EXISTS avatar_url VARCHAR(500) NULL AFTER oauth_id');
    echo "Added avatar_url column\n";
    
    // Make password nullable
    $pdo->exec('ALTER TABLE users MODIFY password VARCHAR(255) NULL');
    echo "Made password column nullable\n";
    
    echo "\nDatabase updated successfully for OAuth support!\n";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
