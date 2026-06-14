<?php 

    include "sima_db.php";

    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
    
    $exe = [];

    if (isset($_POST["name"])){
        $_name=$_POST["name"];
    } else {
        $exe["success"] = "false";
        $exe["error"] = "yes";
        echo json_encode($exe);
        return;
    }

    if (isset($_POST["roll_no"])){
        $_roll_no=$_POST["roll_no"];
    } else {
        $exe["success"] = "false";
        $exe["error"] = "yes";
        echo json_encode($exe);
        return;
    }

    if (isset($_POST["email"])){
        $_email=$_POST["email"];
    } else {
        $exe["success"] = "false";
        $exe["error"] = "yes";
        echo json_encode($exe);
        return;
    }

    if (isset($_POST["cgpa"])){
        $_cgpa=$_POST["cgpa"];
    } else {
        $exe["success"] = "false";
        $exe["error"] = "yes";
        echo json_encode($exe);
        return;
    }
    

    $check_query = "SELECT * FROM `$table_name` WHERE `roll_no` = '$_roll_no'";
    $check_roll = mysqli_query($conn, $check_query);

    $email_check = "SELECT * FROM `$table_name` WHERE `student_email` = '$_email'";
    $check_email = mysqli_query($conn, $email_check);

    if (mysqli_num_rows($check_roll) > 0){
        $exe["success"] = "false";
        $exe["exists"] = "true";
    } else if (mysqli_num_rows($check_email) > 0) {
        $exe["email"] = "true";
    } else {
        $value = "INSERT INTO `$table_name` (`student_name`, `roll_no`, `student_email`, `student_cgpa`) VALUES ('$_name', '$_roll_no', '$_email', '$_cgpa')";
        $add_value = mysqli_query($conn, $value);

        if ($add_value){
            $exe["success"] = "true";
            $exe["exists"] = "registered";
        } else {
            $exe["success"] = "false";
            $exe["exists"] = "error";
        }
    }
    
    echo json_encode($exe);
?>