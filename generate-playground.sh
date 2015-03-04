#!/bin/bash

# concatenate all docs together into README.md
rm ./contents.swift

cat source/header.swift source/*/* source/footer.swift > ./contents.swift

cp ./contents.swift ./Design-Patterns.playground/contents.swift

{ rm contents.swift && awk '{gsub("\\*//\\*:", "", $0); print}' > contents.swift; } < contents.swift
{ rm contents.swift && awk '{gsub("/\\*:", "```\n", $0); print}' > contents.swift; } < contents.swift
{ rm contents.swift && awk '{gsub("\\*/", "\n```swift", $0); print}' > contents.swift; } < contents.swift

{ rm contents.swift && awk 'NR>1{print buf}{buf = $0}' > contents.swift; } < contents.swift

echo "\`\`\`swift
$(cat ./contents.swift)" > ./README.md

zip -r -X Design-Patterns.playground.zip ./Design-Patterns.playground
