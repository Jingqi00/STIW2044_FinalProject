<?php
include_once("dbconnect.php");

$sqlloadpayment = "SELECT * FROM tbl_paymenthistory ";

$result = $conn->query($sqlloadpayment);
if ($result->num_rows > 0) {
    $payment["payment"] = array();
while ($row = $result->fetch_assoc()) {
        $paymentlist = array();
        $paymentlist['paymentID'] = $row['paymentID'];
        $paymentlist['billID'] = $row['billID'];
        $paymentlist['total'] = $row['total'];
        $paymentlist['paidStatus'] = $row['paidStatus'];
        $paymentlist['date'] = $row['date'];

        array_push($payment["payment"],$paymentlist);
    }
    $response = array('status' => 'success', 'data' => $payment);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>