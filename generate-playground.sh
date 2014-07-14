#!/bin/bash
playground ./README.markdown -s ./stylesheet.css && rm -R ./Design-Patterns.playground || mv ./README.playground ./Design-Patterns.playground && zip -r -X Design-Patterns.playground.zip ./Design-Patterns.playground

# no playground?
#
# brew install node
# npm install -g swift-playground-builder