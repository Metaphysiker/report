#!/usr/bin/env bash

result="$(rails runner 'puts Checked.new.wasthereachecktoday?')"

echo "$result"