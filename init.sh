#!/bin/sh
git pull origin master
git submodule update --init --recursive
cd web
ln -s ../repos/Core/PAWS-mvc/htdocs/index.php htdocs/ 
ln -s ../repos/Core/PAWS-mvc/config.php .
ln -s ../../repos/Core/PAWS-mvc/libs/smarty/libs/ libs/smarty/
ln -s ../repos/Core/PAWS-mvc/outputs . 
