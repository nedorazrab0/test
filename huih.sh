#!/usr/bin/env bash

for i in $(seq 2147483647); do
  a=$((a + 1))
done

echo "${a}"
