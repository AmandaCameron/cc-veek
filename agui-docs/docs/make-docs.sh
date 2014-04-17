#!/bin/bash

function compile-agui {
	acg-doc-maker $1
	cat $1.bbcode >>post.bbcode
	rm $1.bbcode
}

bbcode "[namedspoiler=lib-agui Documentation]"

for i in lib-agui/docs/*.md; do
	compile-agui $i
	bbcode "[hr]"
done

bbcode "[/namedspoiler]"