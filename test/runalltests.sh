#!/bin/bash
TESTS=../tests/*

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
			touch ../test/output.pdf
			# mv ../src/$name.pdf ../test/output.pdf
			cd ../test/;./diff.sh $name
			echo "Moved the file"
			rm -f output/images/*
			rm -f golden/images/*
			rm -f differences/*
			rm -f ../src/*.pdf
			rm ../test/output.pdf
		fi
done