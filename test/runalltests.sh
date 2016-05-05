#!/bin/bash
TESTS=../tests/*
rm -f testresults.txt
touch testresults.txt
for f in $TESTS
	do
		if [ ${f##*.} == pal ]
		then
			name=$(basename $f .pal)
			echo $name
			echo $f
			cd ../src; ./pal $f
			compilecmd='make compile'
			cd ../src; eval $compilecmd
			touch ../test/output/outputcopy/output.pdf
			mv ../src/$name.pdf ../test/output/outputcopy/output.pdf
			cd ../test/;./diff.sh $name
			echo "Moved the file"
			rm -f output/images/*
			rm -f golden/images/*
			rm -f golden/goldensplit/*
			rm -f output/outputsplit/*
			rm -f differences/*
			rm -f ../src/*.pdf
			rm ../test/output/outputcopy/output.pdf
		fi
done
