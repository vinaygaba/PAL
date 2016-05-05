#!/bin/bash
OUTPUT=output/outputsplit/*
GOLDEN=golden/goldensplit/*
DIFFERENCE=differences/*
OUTPUTIMAGES1=output/images/
GOLDENIMAGES1=golden/images/

OUTPUTIMAGES2=output/images/*
GOLDENIMAGES2=golden/images/

DIFFERENCEIMAGES=differences/

pdftk output/outputcopy/output.pdf burst output output/outputsplit/output_0%d.pdf

pdftk golden/goldencopy/$1.pdf burst output golden/goldensplit/output_0%d.pdf
for f in $OUTPUT
do
#sips -s format png test_%d.pdf --out test_%d.png

  if [ ${f##*.} == pdf ]
  then
  #echo ${f##*/}
   sips -s format png $f --out $OUTPUTIMAGES1/${f##*/}.png
  fi
done

for f in $GOLDEN
do
#sips -s format png test_%d.pdf --out test_%d.png

  if [ ${f##*.} == pdf ]
  then
  #echo ${f##*/}
   sips -s format png $f --out $GOLDENIMAGES1/${f##*/}.png
  fi
done

for o in $OUTPUTIMAGES2
do
    if [ ${o##*.} == png ]
      then
    #echo ${o##*/}
    compare ${o} $GOLDENIMAGES1${o##*/} -compose Src $DIFFERENCEIMAGES/${o##*/}
    fi
done

flag=1
for d in $DIFFERENCE
do
  colors=$(identify -format "%k" $d)
  if [ $colors -ne 1 ]
  then
    flag=0
    #PID=$!
    #sleep 2
    #kill -s $PID
  fi
done

echo
echo
echo "***************** AUTOMATED PDF COMPARISON *****************"
if [ $flag -eq 1 ]
then
  echo 'Hooray! The pdf generated matches the golden copy'
  echo "Test Case:$1     Result:Passed" >> testresults.txt
else
  echo 'The pdf generated does not match the golden copy'
  echo "Test Case:$1     Result:Failed" >> testresults.txt
fi
#compare $OUTPUTIMAGES/sunshine1.png $GOLDENIMAGES/sunshine2.png -compose Src differences.png

  #pdftk golden.pdf burst output golden/golden_03%d.pdf
