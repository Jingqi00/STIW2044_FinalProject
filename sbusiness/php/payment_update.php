<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$curcredit = $_GET['curcredit'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-_WRL1uQheigE35sLmkvrLQ');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
        $newcredit = $amount + $curcredit;
        $updatecrsql = "UPDATE tbl_users SET user_credit='$newcredit' WHERE user_email='$userid'";
        $sqlinsert  = "INSERT INTO tbl_paymenthistory (billID,total,paidStatus) VALUES ('$receiptid','$amount','$paidstatus')";
        $conn->query($sqlinsert);
        $conn->query($updatecrsql);
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Mobile to</td><td>'.$mobile.'</td></tr><tr><td>Amount </td><td>RM '.$amount. ' </td></tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to MyShop</center></p></div></body>';
    }
    else 
    {
        echo 'Payment Failed!';
    }
}

?>