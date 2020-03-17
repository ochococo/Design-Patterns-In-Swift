#!/bin/bash

# Note: I think this part is absolute garbage but it's a snapshot of my current skills with Bash. 
# Would love to rewrite it in Swift soon.

combineSwiftCN() {
	cat source-cn/startComment > $2
	cat $1/header.md  >> $2
	cat source-cn/contents.md  >> $2
	cat source-cn/endComment >> $2
	cat source-cn/imports.swift >> $2
	cat $1/*.swift >> $2
	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
}

move() {
	mv $1.swift Design-Patterns-CN.playground/Pages/$1.xcplaygroundpage/Contents.swift
}

playground() {
	combineSwiftCN source-cn/$1 $1.swift 
	move $1
}

combineMarkdown() {
	cat $1/header.md  > $2

	{ rm $2 && awk '{gsub("\\*/", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "", $0); print}' > $2; } < $2

	cat source-cn/startSwiftCode >> $2
	cat $1/*.swift >> $2

	{ rm $2 && awk '{gsub("\\*//\\*:", "", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("\\*/", "\n```swift", $0); print}' > $2; } < $2
	{ rm $2 && awk '{gsub("/\\*:", "```\n", $0); print}' > $2; } < $2
	
	cat source-cn/endSwiftCode >> $2

	{ rm $2 && awk '{gsub("```swift```", "", $0); print}' > $2; } < $2

	cat $2 >> README-CN.md
	rm $2
}

readme() {
	combineMarkdown source-cn/$1 $1.md
}

playground Index
playground Behavioral
playground Creational
playground Structural

zip -r -X Design-Patterns-CN.playground.zip ./Design-Patterns-CN.playground

echo "" > README-CN.md

readme Index
cat source-cn/contentsReadme.md >> README-CN.md
readme Behavioral
readme Creational
readme Structural
cat source-cn/footer.md  >> README-CN.md