<?php 

include "sima_db.php";

$query = "SELECT `student_name`, `roll_no`, `student_email`, `student_cgpa` FROM `student_info`";
$run = mysqli_query($conn, $query);

$arr = [];
while ($row = mysqli_fetch_array($run)){
    $arr[] = $row;
}

print(json_encode($arr));
?>