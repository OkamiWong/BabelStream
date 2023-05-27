#!/bin/bash

# Utilities
get-gpu-temperature() {
  echo $(nvidia-smi -q -i 0 -d TEMPERATURE | grep "GPU Current Temp" | grep -E "[0-9]+" -o)
}

SAFE_TEMPERATURE=60

wait-for-cooling-down() {
  current_temperature=$(get-gpu-temperature)
  while ((current_temperature > SAFE_TEMPERATURE)); do
    sleep 3
    current_temperature=$(get-gpu-temperature)
  done
}

# Configurations
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
    wait-for-cooling-down
    $BIN --arraysize $input_size >> $OUTPUT_FILE
  done
done
