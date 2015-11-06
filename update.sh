#!/bin/sh
git pull origin master
git submodule update --init --recursive .
git submodule foreach git pull origin master
