#!/bin/bash

csv_file=$1

#This function sorts the infraction_description column so that the uniq command will be able to remove duplicates. It returns each type of infraction once.
infraction_description () {

	cut -d, -f4 < $csv_file | sort | uniq
}

infraction_description

#This function will sort the set_fine_amount column in ascending order and return the first entry, therefore giving the minimum
min_amount () {

	cut -f5 -d"," $csv_file | sort -n | head -1

}

echo "The minimum fine amount is \$$(min_amount)"

#This function will sort the set_fine_amount column in ascending order and return the last entry, therefore giving the maximum
max_amount () {

	cut -f5 -d"," $csv_file | sort -n | tail -1

}

echo "The maximum fine amount is \$$(max_amount)"

#This function will sum the set_fine_amount column as well as find the total number of entries, and then use those numbers to find the mean
find_the_mean () {
	#sourced from https://stackoverflow.com/questions/22512333/unix-command-to-get-the-count-of-lines-in-a-csv-file
	#initializes the total line count at 0 and adds 1 for each line in the column
	total=0
	for num in $(cut -f5 -d"," $csv_file)
	do
    	((total+=1))
	done
	#sourced from https://www.folkstalk.com/2011/12/methods-to-find-sum-of-numbers-in-file.html
	#initializes the sum variable at 0 and adds each number in the fine_amount column to it
	sum=0
	for num in $(cut -f5 -d"," $csv_file)
	do
	    ((sum+=num))
	done

	echo $((sum / total))


}
echo "The average fine amount is \$$(find_the_mean)"

#This will cut the csv headers then write them to a new file. Then the grep command will find all instances of "STOP ON BRIDGE" and append them to the file.
head -1 $csv_file | cut -f4,5,8 -d","  > ~/desktop/stop_on_bridge.csv | cut -f4,5,8 -d"," $csv_file | grep "STOP - ON BRIDGE"  >> ~/desktop/stop_on_bridge.csv
echo "A new file called stop_on_bridge.csv has been created in the ~/desktop/ directory. It contains all instances of the STOP - ON BRIDGE infraction, as well as the fine amounts and locations of those infractions"