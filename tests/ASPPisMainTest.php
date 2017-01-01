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
        //tests do not work correctly, some negative tests do NOT FAIL (they should) and are still shown as non-failing
        $parser = new ASPPisMain();
        try {
            $parser->parseFile((string)$testFile);
            if($type == 'negativeTest') {
                unset($parser);
                $this->fail($testFile . ': This Query should Fail');
            } else {
            $this->assertFalse($parser->root == null);
            }
        } catch (Exception $e) {
            if($type == 'positiveTest') {
                unset($parser);
                $this->fail($testFile . PHP_EOL . $e);
            } else {
            $this->assertTrue(true);
            }
        }
        unset($parser);
        $this->fail('a');
    }

    public function providerTestW3CQueries()
    {
        $parseArray = array();
        $manifestAllPath = dirname(__FILE__) . '/_files/w3cS11TS/manifest-all.ttl';
        //adds all syntax only Testgroups
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
        //manually add the remaining few tests scattered in the non-syntax groups
        $path = dirname(__FILE__) . '/_files/w3cS11TS/';
        $baseName = 'http://www.w3.org/2009/sparql/docs/tests/data-sparql11/';
        $pos = 'positiveTest';
        $neg = 'negativeTest';
        $parseArray[$baseName . 'aggregates/manifest#agg08'] = array('type' => $neg, 'file' => $path . 'aggregates/agg08.rq');
        $parseArray[$baseName . 'aggregates/manifest#agg09'] = array('type' => $neg, 'file' => $path . 'aggregates/agg09.rq');
        $parseArray[$baseName . 'aggregates/manifest#agg10'] = array('type' => $neg, 'file' => $path . 'aggregates/agg10.rq');
        $parseArray[$baseName . 'aggregates/manifest#agg11'] = array('type' => $neg, 'file' => $path . 'aggregates/agg11.rq');
        $parseArray[$baseName . 'aggregates/manifest#agg12'] = array('type' => $neg, 'file' => $path . 'aggregates/agg12.rq');
        $parseArray[$baseName . 'construct/manifest#constructwhere05'] = array('type' => $neg, 'file' => $path . 'construct/constructwhere05.rq');
        $parseArray[$baseName . 'construct/manifest#constructwhere06'] = array('type' => $neg, 'file' => $path . 'construct/constructwhere06.rq');
        $parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-03'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-03.ru');
        $parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-03b'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-03b.ru');
        $parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-05'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-05.ru');
        //$parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-06'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-05.ru'); uses the same as the previous
        $parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-07'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-07.ru');
        $parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-07b'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-07b.ru');
        $parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-08'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-08.ru');
        $parseArray[$baseName . 'delete-insert/manifest#dawg-delete-insert-09'] = array('type' => $neg, 'file' => $path . 'delete-insert/delete-insert-09.ru');
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
