#!/bin/bash

function compile-agui {
	acg-doc-maker $1
	cat $1.bbcode >>post.bbcode
	rm $1.bbcode
}

bbcode "[namedspoiler=Documentation]"

for i in lib-agui/docs/*.md; do
	if [[ $i != lib-agui/docs/lib-agui.md ]]; then
		compile-agui $i
		bbcode "[hr]"
	fi
done

bbcode "[/namedspoiler]"