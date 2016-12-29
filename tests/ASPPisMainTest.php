<?php
namespace aSPPis\tests;
use aSPPis\ASPPisMain;
use Exception;

class ASPPisMainTest extends \PHPUnit_Framework_TestCase
{

    public function testBasicQueryAndPHP()
    {
        // Arrange
        $parser = new ASPPisMain();

        // Act
        $parser->parseString('BASE <http://www.url.com/> PREFIX abc:<https://test.com/>
        Select * where { ?a ?b ?c }');
        
        $query = $parser->root->query;

        // Assert
        $this->assertEquals('BASE <http://www.url.com/>' . PHP_EOL . 'PREFIX abc:<https://test.com/>' . PHP_EOL . 'SELECT *' . PHP_EOL . 'WHERE { ' . PHP_EOL .'?a ?b ?c' . PHP_EOL . ' }', $query);
    }
    
    /**
     * @dataProvider providerTestW3CQueries
     */
    public function testW3CQueries($type, $testFile)
    {
        $parser = new ASPPisMain();
        try {
            $parser->parseFile($testFile);
            if($type == 'negativeTest') {
                unset($parser);
                $this->fail($testFile . ': This Query should Fail');
            }
            $this->assertFalse($parser->root == null);
        } catch (Exception $e) {
            if($type == 'positiveTest') {
                unset($parser);
                $this->fail($testFile . PHP_EOL . $e);
            }
            $this->assertTrue(true);
        }
        unset($parser);
    }

    public function providerTestW3CQueries()
    {
        $parseArray = array();
        $manifestAllPath = dirname(__FILE__) . '/_files/w3cS11TS/manifest-all.ttl';
        //enable second parameter to only get syntax manifest paths
        $manifestIncludes = $this->importFromManifest($manifestAllPath, true);
        foreach($manifestIncludes as $manifest) {
            $manifestTestNames = $this->importFromManifest($manifest);
            $manifestGraph = new \EasyRdf_Graph();
            $manifestGraph->parseFile($manifest);
            $resource = $manifestGraph->toRdfPhp();
            foreach($manifestTestNames as $testName) {
                $typeUri = $resource[$testName]["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"][0]['value'];
                $typeBool = strpos($typeUri,'Positive');
                $type = false;
                if ($typeBool !== false) {
                    $type = 'positiveTest';
                } else {
                    $type = 'negativeTest';
                }
                $testFile = $resource[$testName]["http://www.w3.org/2001/sw/DataAccess/tests/test-manifest#action"][0]['value'];
                //remove file:// from the queryFilePaths
                $testFile = substr($testFile, 7);
                //adding the testName as name for the key, makes it easy to see which s11ts testcases fail.
                $parseArray[$testName] = array('type' => $type, 'file' => $testFile);
            }
        }
        return $parseArray;
    }

    public function importFromManifest($fileName, $onlySyntax = false)
    {
        $graph = new \EasyRdf_Graph();
        $graph->parseFile($fileName, 'turtle');
        $resource = $graph->toRdfPhp();
        $counter = 1;
        $manifestPaths = array();
        $countString ='_:genid';
        while(true) {
            if(!isset($resource[$countString . $counter])) {
                break;
            }
            if (isset($resource[$countString . $counter]["http://www.w3.org/1999/02/22-rdf-syntax-ns#first"][0]['value'])) {
                $manifestPath = null;
                if ($onlySyntax) {
                    //Strip file:// for filePaths
                    $manifestPath = ($resource[$countString . $counter]["http://www.w3.org/1999/02/22-rdf-syntax-ns#first"][0]['value']);
                    $manifestPath = substr($manifestPath, 7);
                } else {
                    $manifestPath = ($resource[$countString . $counter]["http://www.w3.org/1999/02/22-rdf-syntax-ns#first"][0]['value']);
                }
                //only adds parser relevant(syntax) tests into the array with test manifests, otherwise adds all Testcases
                $isSyntaxTest = strpos($manifestPath,'syntax');
                if ( $onlySyntax != true || $isSyntaxTest !== false) {
                    $manifestPaths[] = $manifestPath;
                }
           }
           $counter++;
       }
       return $manifestPaths;
    }
}
