<?php
// Basic File Upload Example
//
// Accepts POST and GET requests from clients and records and prints the variables received.
//
// NOTE: This is a basic example and should not be made live without further security restrictions
// NOTE: In PHP versions earlier than 4.1.0, $HTTP_POST_FILES should be used instead of $_FILES.


// Log the contents of $_FILES, $_POST and $_GET to log.txt
$fd = fopen("log.txt", "w");
ob_start();
print "FILES:";
print_r($_FILES);
print "POST:";
print_r($_POST);
print "GET:";
print_r($_GET);
fwrite($fd, ob_get_contents());
ob_end_clean();
fclose($fd);


// The directory to drop uploaded files. We'll just drop them in the same dir.
$uploaddir = '';

$filesOK = "";
$filesFault = "";

// run through each file uploaded and attempt to put it in the correct directory
// with the correct file name
foreach ($_FILES as $id => $details)
{
    $targetPath = $uploaddir . basename($details['name']);
    if (move_uploaded_file($details['tmp_name'], $targetPath))
    {
        $filesOK .= "- " . $id . " : " . $details['name'] . "\n"; //"- '" . $details['name'] . "'\n";
    }
    else
    {
        $filesFault .= "- '" . $details['name'] . "'\n";
    }
}

// Run through each post variable received
$postVars = "";
foreach ($_POST as $id => $value)
{
    $postVars .= "- " . $id . " : " . $value . "\n";
}

// Run through each GET variable received
$getVars = "";
foreach ($_GET as $id => $value)
{
    $getVars .= "- " . $id . " : " . $value . "\n";
}

// Print out the results
if ($filesFault != "")
   print "Files which could not be saved on server:\n" . $filesFault . "\n\n";

if ($filesOK != "")
   print "Files successfully uploaded:\n" . $filesOK . "\n\n";

if ($postVars != "")
   print "POST variables uploaded:\n" . $postVars . "\n\n";

if ($getVars != "")
   print "GET variables uploaded:\n" . $getVars;

?>