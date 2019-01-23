<?php

switch ($_GET['view']) {
    case 'faktury' :
        $viewName = 'faktury';
        $orderBy = 'faktura';
        break;
    case 'faktury_pozycje' :
        $viewName = 'faktury_pozycje';
        $orderBy = 'id';
        break;
    default:
        $viewName = 'faktury';
        break;
}
$where1 = !empty($_GET['filter_date']) ? 'WHERE data = :filter_date' : '';
$where2 = !empty($_GET['filter_id']) ? " WHERE symbol = :filter_id" : '';

$orderType = (isset($_GET['sort_type'])) ? "DESC" : "ASC";
$order = $orderBy && $orderType ? " ORDER BY $orderBy $orderType " : '';

$sql = "SELECT * FROM $viewName $where1 $where2 $order";

$queryParams = array();
if ($where1) $queryParams[':filter_date'] = $_GET['filter_date'];
if ($where2) $queryParams[':filter_id'] = $_GET['filter_id'];


$databaseConnection = new PDO("mysql:host=localhost;dbname=test", "doctor", "Azathot");
$databaseConnection->exec("set names utf8");
$statement = $databaseConnection->prepare($sql);
$statement->execute($queryParams);
$data = $statement->fetchAll(PDO::FETCH_ASSOC);
header('Content-Type: application/json');
echo json_encode($data);