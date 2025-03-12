#!/usr/bin/env bash
set -ex

rq(){
  for rq in /sys/block/*/queue/rq_affinity; do
    echo "$1" > "$rq"
  done

  rm -f z
  sleep 1
  dd if=/dev/zero of=z bs=10G count=1 conv=fsync
  sleep 1
}

rq 0
rq 1
rq 2
