#!/usr/bin/env bash

for i in {0..2147483647}; do
  a=$((a + 1))
done

echo "${a}"
