<?php

ini_set('display_errors', 1); 
error_reporting(E_ALL); 

require_once 'Mysql.class.php'; 

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$json = "";

$db = Mysql::singleton();
$query = "SELECT * from demo";
$res = $db->select($query);
$aRes = $res->getArray();
//print_r($aRes);
foreach ($aRes as $k=>$record) {
        $json.= json_encode($record).",";
}
        
$json = json_encode($aRes);
print "{ \"locations\": $json }";

function mLog($msg) {
	$LOG_FILE='./access.log';

	$date = date('m/d/Y h:i:s a', time());
	$data = "\n" . $date . " - " . $msg;
	$fp = fopen($LOG_FILE, 'a');
	fwrite($fp, $data);
	fclose($fp);
}

?>
