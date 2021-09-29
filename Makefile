TMUXIFY_ROOT="$(shell pwd)"

TMP_TMUXIFY=.tmuxify~
tmuxify: src/tmuxify.in Makefile
	rm -f $@
	touch $(TMP_TMUXIFY)
	echo "#!/bin/bash" >$(TMP_TMUXIFY)
	echo "# THIS FILE IS AUTOGENERATED! DO NOT MODIFY!" >>$(TMP_TMUXIFY)
	echo "export TMUXIFY_ROOT=$(TMUXIFY_ROOT)/src" >>$(TMP_TMUXIFY)
	tail -n +3 src/tmuxify.in >>$(TMP_TMUXIFY)
	mv $(TMP_TMUXIFY) $@
	chmod ugo+x $@
	chmod ugo-w $@

clean:
	rm -f $(TMP_TMUXIFY) tmuxify
.PHONY: clean
