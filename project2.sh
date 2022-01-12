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

while true
do
	echo -e "VOLATILITY OPTION LIST:\n"
	echo -e "-------------------------"
	echo -e "1 - imageinfo \n2 - pslist\n3 - connscan\n4 - mftparser <file>\n5 - hashdump\n6 - cmdscan\n7 - <enter PID to check if it exists!>\n8- exit menu"
	read v

	vol1
# Function listing options for the volatility tool.
volopt()
{
	case $v in
		1)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f memory.vmem imageinfo
		;;
		
		2)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f memory.vmem pslist
		;;
	
		3)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f memory.vmem connscan
		;;

		4)
		read p
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f memory.vmem mftparser $p
		;;

		5)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f memory.vmem hashdump --output-file=$PWD/hashes.txt
		cat hashes.txt
		;;

		6)
		cd volatility_2.6_lin64_standalone && ./volatility_2.6_lin64_standalone -f memory.vmem cmdscan
		;;

		#7)
		#read n
		#./volatility_2.6_lin64_standalone -f memory.vmem pslist | grep $n

		8)
		break
		;;
	esac
}
volopt
done
