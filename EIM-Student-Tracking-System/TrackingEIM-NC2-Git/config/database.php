<?php
// config/database.php
// Simple PDO database connection

class Database
{
    private static $charset = 'utf8mb4';
    private static $pdo = null;

    private static function getConfig()
    {
        // Check if running on InfinityFree (production)
        if (strpos($_SERVER['HTTP_HOST'] ?? '', 'infinityfree') !== false) {
            return [
                'host' => 'sql306.infinityfree.com',
                'dbName' => 'if0_41217402_eim_progress_db',
                'username' => 'if0_41217402',
                'password' => 'MX5vaH7AGkWLnJ' // vPanel password
            ];
        }
        // Local development (XAMPP)
        return [
            'host' => '127.0.0.1',
            'dbName' => 'eim_progress_db',
            'username' => 'root',
            'password' => ''
        ];
    }

    public static function getConnection(): PDO
    {
        if (self::$pdo instanceof PDO) {
            return self::$pdo;
        }

        $config = self::getConfig();
        $dsn = 'mysql:host=' . $config['host'] . ';dbname=' . $config['dbName'] . ';charset=' . self::$charset;
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];

        try {
            self::$pdo = new PDO($dsn, $config['username'], $config['password'], $options);
        } catch (PDOException $e) {
            die('Database connection failed: ' . $e->getMessage());
        }

        return self::$pdo;
    }
}
