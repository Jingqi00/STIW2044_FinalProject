<?php

include_once("dbconnect.php");

$email = $_POST['email'];
$sqluser = "SELECT * FROM tbl_users WHERE user_email = '$email'";

$result = $conn->query($sqluser);
if ($result->num_rows > 0) {
while ($row = $result->fetch_assoc()) {
        $userlist = array();
        $userlist['username'] = $row['user_username'];
        $userlist['name'] = $row['user_name'];
        $userlist['phoneno'] = $row['user_phoneno'];
        $userlist['email'] = $row['user_email'];
        $userlist['password'] = $row['user_password'];
        $userlist['credit'] = $row['user_credit'];
        echo json_encode($userlist);
        $conn->close();
        return;
    }
}else{
    echo "failed";
}
?>