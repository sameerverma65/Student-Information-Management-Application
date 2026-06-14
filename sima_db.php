<?php 
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
    $hostname="localhost";
    $username="root";
    $password="";

    $dbname="student_db";

    try{
        $conn = mysqli_connect($hostname, $username, $password);

        if ($conn -> connect_error){
            print("Error: " . $conn -> connect_error);
        }

        $create_db = "CREATE DATABASE IF NOT EXISTS `$dbname`";
        mysqli_query($conn, $create_db);
        mysqli_select_db($conn, $dbname);

        $table_name = "student_info";
        $table = "CREATE TABLE IF NOT EXISTS `$table_name` (
        `student_name` VARCHAR(50) NOT NULL, 
        `roll_no` VARCHAR(50) NOT NULL PRIMARY KEY, 
        `student_email` VARCHAR(50) NOT NULL, 
        `student_cgpa` FLOAT NOT NULL
        )";
    
        $create_table = mysqli_query($conn, $table);
    }
    catch (e){
        print("Error: ". $e);
    }

?>