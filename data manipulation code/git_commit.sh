#!/bin/sh -e
cd C:/Users/mhauenst/Documents/sbeconomydb/
git add --all
timestamp() {
  date +"on %m/%d/%Y at %H:%M:%S"
}
git commit -am "Auto-commit data updates $(timestamp)"
git push origin main