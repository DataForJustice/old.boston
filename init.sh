#!/bin/sh
git submodule update --init --recursive
cd web/htdocs;
ln -s ../../repos/Core/PAWS-mvc/htdocs/index.php .
