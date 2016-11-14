<?php
use PHPUnit\Framework\TestCase;
require(__DIR__ . '/../SparqlPHPParserMain.php');
class SparqlPHPParserMainTest extends TestCase
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
}
