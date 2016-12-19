PHPUNIT = ./vendor/bin/phpunit
JLEX_JAR = vendor/shinobu/jlex-php/JLexPHP.jar
LEMON = ./vendor/shinobu/lemon-php/lemon

update_parser:
	$(LEMON) -LPHP resource/sparql.y
	rm resource/sparql.out
	mv resource/sparql.php lib/sparql.php
update_lexer:
	java -cp $(JLEX_JAR) JLexPHP.Main resource/sparql.lex
	mv resource/sparql.lex.php lib/sparql.lex.php
phpunit:
	$(PHPUNIT)
