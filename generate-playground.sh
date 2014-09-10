#!/bin/bash
rm -R ./Design-Patterns.playground
playground ./README.markdown -p ios -s ./stylesheet.css && mv ./README.playground ./Design-Patterns.playground && zip -r -X Design-Patterns.playground.zip ./Design-Patterns.playground

# no playground?
#
# brew install node
# npm install -g swift-playground-builder