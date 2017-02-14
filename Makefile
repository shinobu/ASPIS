PHPUNIT = ./vendor/bin/phpunit
JLEX_JAR = vendor/shinobu/jlex-php/JLexPHP.jar
LEMON = ./vendor/shinobu/lemon-php/lemon

update_parser:
	$(LEMON) -LPHP resource/ASPISParser.y
	rm resource/ASPISParser.out
	mv resource/ASPISParser.php lib/ASPISParser.php
update_lexer:
	java -cp $(JLEX_JAR) JLexPHP.Main resource/ASPISLexer.lex
	mv resource/ASPISLexer.lex.php lib/ASPISLexer.php
phpunit:
	$(PHPUNIT)
