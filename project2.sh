#!/bin/bash

# Function that checks if volatility is installed in the current dir.

vol1()
{
	exists=$(find . -type f -name volatility_2.6_lin64_standalone)
	if [[ $exists == './volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone' ]]
	then
		echo "Volatility is installed!"
	else
		wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip
		unzip volatility_2.6_lin64_standalone.zip && cd volatility_2.6_lin64_standalone
		echo "Now installing volatility!"
	fi
}
vol1

while true
do
	echo -e "VOLATILITY OPTION LIST:\n"
	echo -e "-------------------------"
	echo -e "1 - imageinfo \n2 - pslist\n3 - connscan\n4 - mftparser <file>\n5 - hashdump\n6 - cmdscan\n7 - <enter PID to check if it exists!>\n8- exit menu"
	read v

# Function listing options for the volatility tool.
volopt()
{
	case $v in
		1)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f $file_name imageinfo
		;;
		
		2)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f $file_name pslist
		;;
	
		3)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f $file_name connscan
		;;

		4)
		read p
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f $file_name mftparser $p
		;;

		5)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f $file_name hashdump --output-file=$PWD/hashes.txt
		cat hashes.txt
		;;

		6)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f $file_name cmdscan
		;;

		#7)
		#read n
		#./volatility_2.6_lin64_standalone -f $file_name pslist | grep $n | 
		#;;
		
		8)
		exit 1
		;;
	esac
}
volopt
done
brute()
{
	if [[ $v == '5' ]]
	then
		hashcat -a 0 -m 5600 $PWD/hashes.txt
		echo -e "The brute forced hashes are" $(cat hashes.txt)\n
	fi
}
usage()
{
	if [[ $# -ne 1 ]]
	then
		echo "Usage: ./project2.sh <file name>"
		exit 1
	fi
	file_name=$1
}
