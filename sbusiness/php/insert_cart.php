<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$productName= $_POST['productName'];
$productDescription = $_POST['productDescription'];
$productPrice = $_POST['productPrice'];
$productQuantity = $_POST['productQuantity'];
$productState = $_POST['productState'];
$productLoc = $_POST['productLoc'];
$cartQuantity = $_POST['cartQuantity'];


$sqlinsert = "INSERT INTO tbl_cart (productName,productDescription,productPrice,productQuantity,productState,productLoc,cartQuantity) VALUES('$productName','$productDescription','$productPrice','$productQuantity','$productState','$productLoc','$cartQuantity')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>