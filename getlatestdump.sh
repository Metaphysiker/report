#!/usr/bin/env bash
#/usr/local/bin/bash
cd /home/sandro/Documents/philochbackups/
DUMP=$(ls -t | head -1)
readlink -f $DUMP
