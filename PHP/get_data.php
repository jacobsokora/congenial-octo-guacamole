<?php
 
$con=mysqli_connect("sql103.epizy.com","epiz_21985748","scavengr","epiz_21985748_scavengerdb");
 
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL. Error: " . mysqli_connect_error();
}
 
$sql = "SELECT * FROM Users";
 
if ($result = mysqli_query($con, $sql))
{

	$resultArray = array();
	$tempArray = array();
 
	while($row = $result->fetch_object())
	{
		$tempArray = $row;
	    array_push($resultArray, $tempArray);
	}
 
	echo json_encode($resultArray);
}
 
 mysqli_close($con);
?>