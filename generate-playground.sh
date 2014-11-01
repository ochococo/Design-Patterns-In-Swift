#!/bin/bash

# concatenate all docs together into README.md
cat docs/header.md docs/*/* docs/footer.md > README.md

# remove the old Design-Patterns.playground
rm -R ./Design-Patterns.playground

# see (https://www.npmjs.org/package/playground) to understand playground executable
playground ./README.md --platform ios --stylesheet ./stylesheet.css

# rename readme for new playground
mv ./README.playground ./Design-Patterns.playground

zip -r -X Design-Patterns.playground.zip ./Design-Patterns.playground

# no playground?
#
# brew install node
# npm install -g playground
