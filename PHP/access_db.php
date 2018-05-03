<?php
 
//establish MySQL connection
$con=mysqli_connect("sql103.epizy.com","epiz_21985748","scavengr","epiz_21985748_scavengerdb"); 
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL. Error: " . mysqli_connect_error();
}
//check if 'choice' parameter was included in GET request. If not, exit. NOTE: we have to use GET because POST requests are only allowed
//on infinityfree's paid service
$choice = null;
if(isset($_GET['choice']))
{
    $choice = $_GET["choice"];
}
else
{
    echo "Error: no 'choice' parameter found.";
    exit();
}
//this switch routes all app requests based on 'choice' parameter
switch($choice)
{
    case "gethunts":
        getHunts();
        break;
    case "addhunt":
        addHunt();
        break;
    case "deletehunt":
        deleteHunt();
        break;
    case "addclue":
        addClue();
        break;
    default:
        echo "Invalid 'choice' value";
        break;
}
mysqli_close($con);
//add a scavenger hunt to the database
function addHunt()
{
    global $con;
    $sql = "INSERT INTO Hunts(name, ownerId, location, date, description) VALUES ('".$_GET['name']."', '".$_GET['ownerId']."', '".$_GET['location']."', NOW(), '".$_GET['description']."')";
    if ($con->query($sql) === TRUE) {
        echo "New record created successfully";
    } 
    else {
        echo "Error: " . $sql . "<br>" . $con->error;
    }
    $clueArray = array();
    $clueArray = $_GET['clues'];
    $arrlength=count($clueArray);
    for($x=0; $x<$arrlength; $x++){
        addClue($clueArray[$x]);
    }
    mysqli_close($con);
    exit();
}
function deleteHunt(){
    global $con;
    $id = $_GET['id'];
    $sql = "DELETE FROM Hunts WHERE id= $id";
    if ($con->query($sql) === TRUE) {
        echo "Record deleted successfully";
    } else {
        echo "Error deleting record: " . $con->error;
}
    mysqli_close($con);
    exit();
    
}
function addClue($text){
    global $con;
    $code = generateRandomString();
    $sql = "INSERT INTO Clues(huntId, clueText, clueCode) VALUES ('".$_GET['huntId']."', '$text', '$code')";
    if ($con->query($sql) === TRUE) {
        echo "New record created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $con->error;
    }
    
    //mysqli_close($con);
    //exit();
}
 
//get all scavenger hunts and their corresponding clues in order
function getHunts()
{
    global $con;
    $sql = "SELECT id, name, description, location, ownerId FROM Hunts WHERE 1";
    
    
    if ($result = mysqli_query($con, $sql))
    {
        $resultArray = array();
        while($row = $result->fetch_object())
        {
            $tempArray = json_decode(json_encode($row), true);
            if($clueResult = mysqli_query($con, "SELECT clueText, clueCode FROM Clues WHERE huntId = " . $row->id . " ORDER BY Clues.id ASC"))
            {    
                $temptempArray = array();
                $tempArray["clues"] = array();
                while($clueRow = $clueResult->fetch_object())
                {
                    $temptempArray = json_decode(json_encode($clueRow), true);
                    array_push($tempArray["clues"], $temptempArray);
                }
            }
            
            array_push($resultArray, $tempArray);
        }
        echo json_encode($resultArray);
    }
    mysqli_close($con);
    exit();
}
function generateRandomString($length = 5) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}
?>
