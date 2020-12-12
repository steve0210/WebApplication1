#!/usr/bin/env bash

APP_ENV=$1
SERVICE=$2

if [ -z "$APP_ENV" ]; then
  echo "Usage env.sh <rails environment>"; exit
fi

for file in $FILES; do
  echo "Modifying $file"
  for e in APP_ENV SERVICE; do
    val=$(eval "echo \$$e")
    if [ -n "$val" ] && grep -q "^${e}=" ./$file; then 
      echo "  Setting $e to \"$val\""
      sed -i -e "s#^$e=.*#$e=\"$val\"#" ./$file
    fi
  done
done
