#!/bin/sh

if [ -f $HOME/.psbashrc ]; then . $HOME/.psbashrc; fi

ssh asbw 'ls -l'
