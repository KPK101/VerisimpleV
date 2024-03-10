echo "Generating ground truth outputs from original processor"
cd ~/4824/your_p3_original
# This only runs *.s files. How could you add *.c files?
for source_file in programs/*.s programs/*.c; do
	if [ "$source_file" = "programs/crt.s" ]
	then
		continue
	fi
	program=$(echo "$source_file" | cut -d '.' -f1 | cut -d '/' -f 2)
	echo "Running $program"
	# TODO - should be one line
	make $program".out" 
done
