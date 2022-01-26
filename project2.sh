#!/bin/bash

# This if statement takes an argument(file) from the user
if [[ $# -ne 1 ]]
then
	echo "Usage: ./project2.sh <file name>"
	exit 1
fi

file_name=$1

mv $1 $PWD/volatility_2.6_lin64_standalone

# Function that uses the bulk_extractor tool
bulk()
{
	bulk_extractor $file_name -o bulkout
	echo "Bulk extractor output directory created!"

}
# Function that uses the foremost tool
fore()
{
	foremost -i $file_name -o forout
	cd forout
	cat audit.txt
}

# Function that checks if volatility is installed in the current dir.
vol1()
{
	fexists=$(find . -exec file volatility_2.6_lin64_standalone \; | grep -i elf | awk '{print $1, $2}' | uniq -d)
	dexists=$(find . -type d -name volatility_2.6_lin64_standalone)
	if [[ $fexists == 'volatility_2.6_lin64_standalone: ELF' ]] 
	then
		echo "Volatility is installed!"

	elif [[ $dexists == './volatility_2.6_lin64_standalone' ]]
	then
		echo "Volatility is installed!"
	
	else
		wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip
		unzip volatility_2.6_lin64_standalone.zip && cd volatility_2.6_lin64_standalone
		echo "Now installing volatility!"
	fi
}
# Function listing the input menu for the volatility tool
volmenu()
{
while true
do
	echo -e "VOLATILITY OPTION LIST:\n"
	echo -e "-------------------------"
	echo -e "1 - imageinfo \n2 - pslist\n3 - connscan\n4 - mftparser <file>\n5 - hashdump\n6 - cmdscan\n7 - <enter PID to check if it exists!>\n8- exit menu"
	read v

# Function listing options and code for the volatility tool.
volopt()
{
	case $v in
		1)
		./volatility_2.6_lin64_standalone -f $file_name imageinfo
		;;
		
		2)
		./volatility_2.6_lin64_standalone -f $file_name pslist
		;;
	
		3)
		./volatility_2.6_lin64_standalone -f $file_name connscan
		;;

		4)
		echo "Enter a file name: "
		read p
		./volatility_2.6_lin64_standalone -f $file_name mftparser | grep $p.exe
		;;

		5)
		./volatility_2.6_lin64_standalone -f $file_name hashdump --output-file=$PWD/hashes.txt
		#cat hashes.txt
		;;

		6)
		./volatility_2.6_lin64_standalone -f $file_name cmdscan
		;;

		7)
		echo "Enter a PID: "
		read n
		./volatility_2.6_lin64_standalone -f $file_name pslist | awk '{print $2," |  ",$3, " | ", $4 }'|  grep $n
		;;

		8)
		mv $file_name ../
		exit 1
		;;
	esac
}
volopt
done

}

str()
{
	strings $file_name > strout.txt	
	echo "String output created 'strout.txt'"
}

# Function that asks the user what tool they would like to use
tool_()
{
	case $tool in
		
		foremost)
		fore
		;;

		bulk_extractor)
		bulk
		;;

		volatility)
		cd volatility_2.6_lin64_standalone
		echo "Checking if volatility is installed....."
		vol1
		volmenu
		;;
		
		strings)
		str
		;;

		exit)
		exit 1
	esac
}

if [[ $file_name =~ ".img" ]] || [[ $file_name =~ ".vmem" ]] ;then
	echo -e "Welcome to Ream's forensic analyzer script! Which tool would you like to use for your file?"
	echo -e "Please enter one of the following options:\n'foremost'\n'bulk_extractor'\n'volatility'\n'strings' tool for memory files.\n'exit'"
	read tool
	tool_
else
	echo "Please enter a .vmem or .img file type!"
fi

brute()
{
	john --format=NT $PWD/hashes.txt -o cracked.txt
	echo -e "The brute forced hashes are $(cat cracked.txt)\n"
}

if [[ $v == '5' ]]
then
	brute
fi

#profile=$(./volatility_2.6_lin64_standalone -f memory.vmem imageinfo | cut -d : -f2 | cut -d ',' -f1 | sed -n 1p)
