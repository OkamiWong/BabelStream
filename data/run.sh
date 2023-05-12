#!/bin/bash

BIN="../build/cuda-stream"

# INPUT_SIZES="1024 2048"
INPUT_SIZES=()
BASE_INPUT_SIZE=$((4*1024*1024))
for ((i=0;i<20;i++)); do
  INPUT_SIZES+=($((i*BASE_INPUT_SIZE + BASE_INPUT_SIZE)))
done

OUTPUT_FILE="./data.csv"

HEADER="function,num_times,n_elements,sizeof,max_mibytes_per_sec,min_runtime,max_runtime,avg_runtime"

echo $HEADER > $OUTPUT_FILE
for input_size in ${INPUT_SIZES[*]}; do
  for ((i=0;i<1;i++)); do
    $BIN --arraysize $input_size >> $OUTPUT_FILE
  done
done
