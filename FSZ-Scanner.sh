#!/bin/bash

p="/storage/emulated/0/Download"
p="/storage/emulated/0"

declare -A file_counts
declare -A file_sizes

print_file_info(){
  IFS=" "
  for ext in ${!file_counts[@]}
  do
    local val_asoc=(${file_counts[$ext]})
    echo -e "\033[2K ${val_asoc[0]} => $ext files | size $(numfmt --to=iec --suffix=B ${val_asoc[1]})"
  done
}

scanned=0
path_handle(){
  IFS=" "
  local path_=$1
  local file_ext=($(basename "$path_" | tr "." " "))
  local new_size=$(stat --printf="%s" "$path_")
  if [ ${#file_ext[@]} -gt 1 ]; then
    local file_ext=${file_ext[-1]}
    local old_data=(${file_counts[$file_ext]})
    local to_add="$(( ${old_data[0]}+1 )) $(( ${old_data[1]}+$new_size ))"
    file_counts[$file_ext]=$to_add
  else
    local old_data=(${file_counts["invalid"]})
    local to_add="$(( ${old_data[0]}+1 )) $(( ${old_data[1]}+$new_size ))"
    file_counts["invalid"]=$to_add
  fi
  scanned=$(($scanned+1))
  #printf -v pointer "%b" "\\033[$(( ${#file_counts[@]}+6 ))A\r"
  #echo "$pointer"
  #print_file_info
  echo -e "\033[6A"
  echo -e "\033[2K <------- INFO ------->"
  echo -e "\033[2K Type : $file_ext"
  echo -e "\033[2K Size : $new_size B"
  echo -e "\033[2K ${#file_counts[*]} extensions discovered          "
  echo -e "\033[2K $scanned files scanned.          "
  IFS=$'\n'
}

old_ifs=$IFS
IFS=$'\n'
echo -e "\n"
for item in $(find $p -type f)
do
  path_handle $item
done

echo -e "\nScan finished !!!"
log_file="Scan_$(date -Iminutes | tr ": +" "-").txt"
print_file_info &> "$log_file"
echo "Output have been saved in file $log_file"

