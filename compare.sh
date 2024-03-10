echo "Comparing ground truth outputs to new processor"

echo_color() {
# check if in a terminal and in a compliant shell
# use tput setaf to set the ANSI Foreground color based on the number 0-7:
# 0:black, 1:red, 2:green, 3:yellow, 4:blue, 5:magenta, 6:cyan, 7:white
# other numbers are valid, but not specified in the man page
if [ -t 0 ]; then tput setaf $1; fi;
# echo the message in this color
echo -e "${@:2:$#}"
# reset the terminal color
if [ -t 0 ]; then tput sgr0; fi
}
# Note to generate the groung truths, the generate script was used on the unchanged pipeline. 
# Then the modification required for Project-3 Milestone was made and the new outputs were generated for comparison

for source_file in programs/*.s programs/*.c; do
	
	if [ "$source_file" = "programs/crt.s" ]
	then
		continue
	fi
	program=$(echo "$source_file" | cut -d '.' -f1 | cut -d '/' -f 2)

	
	echo -e "**********\n"
	echo "Running $program"
	make $program.out
	
	echo -e "\nComparing writeback outputs for $program"
	wb_correct="./correct_output/$program.wb"
    wb_generated="./output/$program.wb"
    
     if [ -f "$wb_correct" ]; then
        diff "$wb_correct" "$wb_generated" > /dev/null
        if [ $? -eq 0 ]; then
            echo_color 2 "Writeback output for $program - Passed!\n"
        else
        	echo_color 1 "Writeback output for $program - Failed!\n" 
        fi
    fi
	
	echo -e "Comparing memory outupts for $program"
	out_correct="./correct_output/$program.out"
    out_generated="./output/$program.out"
  
	if [ -f "$out_correct" ]; then
		if diff <(grep -q "^@@@" "$out_correct") <(grep -q "^@@@" "$out_generated"); then
			echo_color 2 "Memory output for $program - Passed!\n"
		else
			echo_color 1 "Memory output for $program - Failed!\n"
		fi
	fi
	
	echo -e "\nProcessed $program"
	
	echo -e "\n**********"
		


done



