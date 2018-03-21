#!/bin/bash
while inotifywait "$1" ; do
  gulp styles;
done
