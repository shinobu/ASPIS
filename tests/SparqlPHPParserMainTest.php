<?php
require(__DIR__ . '/../SparqlPHPParserMain.php');
class SparqlPHPParserMainTest extends \PHPUnit_Framework_TestCase
{

    public function testBasicQueryAndPHP()
    {
        // Arrange
        $parser = new SparqlPHPParserMain();

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
    public function testW3CQueries($query)
    {
        $parser = new SparqlPHPParserMain();
        try {
            $parser->parseFile($query->file);
            if($query->type === 'negativeTest') {
                unset($parser);
                $this->fail($query->file . ': This Query should Fail');
            }
            $this->assertFalse($parser->root == null);
        } catch (Exception $e) {
            if($query->type === 'positiveTest') {
                unset($parser);
                $this->fail($query->file . PHP_EOL . $e);
            }
            $this->assertNull($parser->root);
        }
        unset($parser);
    }

    public function providerTestW3CQueries()
    {
        $parseArray = array();
        $manifestAllPath = dirname(__FILE__) . '_files/w3cS11TS/manifest-all.ttl';
        //enable second parameter to only get syntax manifest paths
        $manifestIncludes = $this->importFromManifest($manifestAllPath, true);
        foreach($manifestIncludes as $manifest) {
            //the substr removes file:// from the filepath
            $manifestTestNames = $this->importFromManifest(substr($manifest, 7));
            foreach($manifestTestNames as $testName) {
                $manifestGraph = new EasyRdf_Graph();
                $manifestGraph->parseFile($manifest);
                $resource = $manifestGraph->toRdfPhp();
                $typeUri = $resource[$testName]["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"][0]['value'];
                $typeBool = strpos($typeUri,'Positive');
                if ($typeBool !== false) {
                    $type = 'positiveTest';
                } else {
                    $type = 'negativeTest';
                }
                $testFile = $resource[$testName]["http://www.w3.org/2001/sw/DataAccess/tests/test-manifest#action"][0]['value'];
                //adding the testName as name for the key, makes it easy to see which s11ts testcases fail.
                $parseArray[$testName] = array('type' => $type, 'file' => $file);
            }
        }
        return $parseArray;
    }

    public function importFromManifest($filename, $onlySyntax = null)
    {
        $graph = new EasyRdf_Graph();
        $graph->parseFile($fileName, 'turtle');
        $resource = $graph->toRdfPhp();
        $counter = 1;
        $manifestPaths = array();
        $s ='_:genid';
        while(true) {
           if(!isset($resource[$s . $counter])) {
               break;
           }
           if (isset($resource[$s . $counter]["http://www.w3.org/1999/02/22-rdf-syntax-ns#first"][0]['value'])) {
               $manifestPath = ($resource[$s . $counter]["http://www.w3.org/1999/02/22-rdf-syntax-ns#first"][0]['value']);
               //only adds parser relevant(syntax) tests into the array with test manifests
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
