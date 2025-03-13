#!/bin/bash

p="/storage/emulated/0/Download"
#p="/storage/emulated/0"
log_file="Scan_$(date -Iminutes | tr ": +" "-").txt"

if [[ $1 == "--help" ]]
then
  echo -e "Syntax :\n  ./FSZ-Scanner.sh -p=\"path_to_scan\" -o=\"output_file_name\"\n\n-p : Tells the script which path to scan, if user wants to scan whole system so run the script as super-user and provide / in -p.\n\n-o : (optional) When scan completes so it will save output into a file so that user can check it or share it, user can decide output file name using this argument.\n"
  exit 0
fi

case $# in
  0) echo "No option provided, running in default settings.";;
  1)
    if [[ $1 == "-p="* ]]; then
      p=${1:3}
    else
      echo "First parameter is incorrect, please check --help"
      exit 3
    fi
    ;;
  2)
    if [[ $1 == "-p="* ]] && [[ $2 == "-o="* ]]; then
      p=${1:3}
      log_file=${2:3}
    else
      echo "invalid arguments, please check --help"
      exit 3
    fi
    ;;
  *)
    echo "invalid number of arguments provided, please check --help"
    exit 3
    ;;
esac

declare -A file_counts

print_file_info(){
  IFS=" "
  for ext in ${!file_counts[@]}
  do
    local val_asoc=(${file_counts[$ext]})
    echo -e "${val_asoc[0]} => $ext files | size $(numfmt --to=iec --suffix=B ${val_asoc[1]})"
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
    local to_add="$(( ${old_data[0]}+1 )) $(( ${old_data[1]}+10#0$new_size ))"  # 10#0 will add 0 in prefix of number in case of file size is '' so it become 0 | 10# to convert it in decimal
    file_counts[$file_ext]=$to_add
  else
    local old_data=(${file_counts["invalid"]})
    local to_add="$(( ${old_data[0]}+1 )) $(( ${old_data[1]}+$new_size ))"
    file_counts["invalid"]=$to_add
  fi
  scanned=$(($scanned+1))
  echo -e "\033[6A"
  echo -e "\033[2K\033[0;32m <------- INFO ------->"
  echo -e "\033[2K Type : $file_ext"
  echo -e "\033[2K Size : $new_size B"
  echo -e "\033[2K\033[0;36m ${#file_counts[*]} extensions discovered."
  echo -e "\033[2K\033[0;36m $scanned files scanned."
  IFS=$'\n'
}

ls "$p" &> /dev/null
if [ $? -ne 0 ]; then
  echo "Error : Given path not found"
  exit $?
fi

old_ifs=$IFS
IFS=$'\n'
echo -e "\033[0;35mScanning into : $p"
echo -e "\n\n\n\n\n"
initial_time=$(date +%s.%N)
for item in $(find $p -type f)
do
  path_handle $item
done
final_time=$(date +%s.%N)
echo -e "\n\033[0;32mScan finished !!!"
printf "\033[0;35mTime taken : %.2fsec\n" $(echo "$final_time-$initial_time" | bc)
print_file_info &> "$log_file"
echo -e "\033[0;33mOutput have been saved in file \033[1;33m$log_file\033[0m"
