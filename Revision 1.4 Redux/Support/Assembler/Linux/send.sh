#!/bin/bash

# Send input with delay
while IFS= read -r line; do
  echo -ne "${line}\n" > /dev/ttyUSB0 # /dev/stdout for testing
  sleep 0.0001 # wait 100µs for the Minimal to decode a line
done

