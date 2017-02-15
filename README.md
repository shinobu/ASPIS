# ASP²IS

| CI System      |                         Status                                                                                                  | 
| -------------- | ----------------------------------------------------------------------------------------------------------------                |
| Travis CI      | [![Travis CI Build Status](https://travis-ci.org/shinobu/ASPIS.svg)](https://travis-ci.org/shinobu/ASPIS) |

Informations about Copyright are in the COPYING and License files.

In general you need get composer and call `composer install` in the projectroot

To Parse a Query just create a ASPIS Object and call

aspis->parseFile($file)
or
aspis->parseString($string)

you will get the root of the syntaxtree in aspis->root

to re-generate the lexer and the parser you need to install the repos necessary for it
do your changes on the files in the resource folder and call the makefile functions

make update_lexer
or
make update_parser

For creating the Parser those tools were used:

https://github.com/wez/JLexPHP

https://github.com/wez/lemon-php
