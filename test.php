<?php 

include 'ASPPisMain.php';

//$parser = new ASPPisMain();
//$parser->parseString('');
//print_r(PHP_EOL);
//print_r($parser->root->query);
$allNS = array();
function addNS($alias, $iri) {
    $allNS[$alias] = $iri;
    var_dump($allNS);
}

function checkNS($alias) {
    if ($alias == null) {
        return false;
    }
    //alias contains the part after the : as well, so it needs to be stripped, first locate the position
    $pos = strpos($alias, ':');
    if($pos !== false) {
        //keep : as an empty prefix is allowed
        $strippedAlias = substr($alias, 0, $pos+1);
        print($strippedAlias);
        if (isset($allNS[$strippedAlias])) {
            return true;
        }
    }
    return false;
}
$test1 = ':function';
$test2 = 'a:function';
addNS(':', '<http://example/>');
var_dump($allNS);
var_dump(checkNS($test1));
print PHP_EOL;
var_dump(checkNS($test2));
 ?>
