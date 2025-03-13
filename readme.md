# FSZ-Scanner
FSZ-Scanner (*File Size Scanner*) is a tool which scan files at given path and gives number of files and there total size on system group by there extension.  

# Installation
### For termux
```
apt update && apt upgrade -y
pkg install git -y
pkg install bc -y
git clone https://github.com/PowerPizza/FSZ-Scanner
cd FSZ-Scanner
chmod +x FSZ-Scanner.sh
clear
```
### For Linux
I don't have PC for now

# Arguments
**-p** : It specifics path in which you want to scan files. Just use put `-p="/"` if want to scan whole file system. By default its `"/storage/emulated/0/Downloads` according to my file system.

**-o** : Its an optional argument which specifics output file name in which all the files group by there extensions with there count and size in system are stored after scan gets completed, just in case if you want custom file name in output then you can use this option.

# Usage
```
./FSZ-Scanner -p="/"
OR
./FSZ-Scanner -p="/storage/emulated/0" -o="scan1.text"
```

# Limitations
* If there is a lot of files is your system so it will take time.

* All files having no extensions are `invalid` file according to this tool which you can see into output file as `(2 => invalid file | size 45KB)`
