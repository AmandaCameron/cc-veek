#!/bin/bash

function compile-agui {
	acg-doc-maker $1
	cat $1.bbcode >>post.bbcode
	rm $1.bbcode
}

bbcode "[namedspoiler=Documentation]"

for i in agui-docs/docs/*.md; do
	compile-agui $i
	bbcode "[hr]"
done

bbcode "[/namedspoiler]"