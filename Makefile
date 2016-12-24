PHPUNIT = ./vendor/bin/phpunit
JLEX_JAR = vendor/shinobu/jlex-php/JLexPHP.jar
LEMON = ./vendor/shinobu/lemon-php/lemon

update_parser:
	$(LEMON) -LPHP resource/ASPPisParser.y
	rm resource/ASPPisParser.out
	mv resource/ASPPisParser.php lib/ASPPisParser.php
update_lexer:
	java -cp $(JLEX_JAR) JLexPHP.Main resource/ASPPisLexer.lex
	mv resource/ASPPisLexer.lex.php lib/ASPPisLexer.php
phpunit:
	$(PHPUNIT)
