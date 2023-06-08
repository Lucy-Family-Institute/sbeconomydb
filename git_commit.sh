#!/bin/sh -e
cd C:/Users/mhauenst/Documents/sbeconomydb/
git add --all
timestamp() {
  date +"at %H:%M:%S on %d/%m/%Y"
}
git commit -am "Auto-commit data updates $(timestamp)"
git push origin main