WGET = wget
GIT = git
BOWER = ./bowerphp
BOWER_URL = http://bowerphp.org/bowerphp.phar

repo_update:
	$(GIT) pull origin master
	$(GIT) submodule update --init --recursive .
	$(GIT) submodule foreach --recursive git pull origin master
	$(GIT) submodule update --recursive
links: 
	ln -s repos/Core/PAWS-mvc/htdocs/index.php web/htdocs/ 
	ln -s repos/Core/PAWS-mvc/config.php web/
	ln -s repos/Core/PAWS-mvc/libs/smarty/libs/ web/libs/smarty/
	ln -s repos/Core/PAWS-mvc/outputs web/ 
	ln -s bower_components/jquery/dist/jquery.min.js web/htdocs/js/
	ln -s bower_components/queue-async/queue.min.js web/htdocs/js/
	ln -s bower_components/d3/d3.min.js web/htdocs/js/ 
	ln -s bower_components/scrollmagic/scrollmagic/minified/ScrollMagic.min.js web/htdocs/js/
bower_init: 
	$(WGET) $(BOWER_URL)
	mv bowerphp.phar $(BOWER) 
	chmod +x $(BOWER)
	$(BOWER) install jquery
	$(BOWER) install d3
	$(BOWER) install queue-async 
	$(BOWER) install scrollmagic
bower_update:
	find . -name bower.json -exec dirname {} \; | xargs -I {} $(BOWER) -d={} update
update: repo_update bower_update
init: repo_update bower_init links
install: init update 
