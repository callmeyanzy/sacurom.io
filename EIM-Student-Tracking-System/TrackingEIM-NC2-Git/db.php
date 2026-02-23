<?php
$server = "sql306.infinityfree.com";
$user = "if0_41217402";
$password = "MX5vaH7AGkWLnJ";
$dbname = "if0_41217402_eim_progress_db";

$conn = new mysqli($server, $user, $password, $dbname);

if (!$conn) {
    echo "Error!: {$conn->connect_error}";
} else {
    echo "Database connected successfully!";
}
?>
