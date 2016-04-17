#!/bin/bash
OUTPUT=output/*
GOLDEN=golden/*
DIFFERENCE=differences/*
OUTPUTIMAGES1=output/images/
GOLDENIMAGES1=golden/images/

OUTPUTIMAGES2=output/images/*
GOLDENIMAGES2=golden/images/

DIFFERENCEIMAGES=differences/

pdftk output.pdf burst output output/output_0%d.pdf

pdftk golden.pdf burst output golden/output_0%d.pdf
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
else
  echo 'The pdf generated does not match the golden copy'
fi
#compare $OUTPUTIMAGES/sunshine1.png $GOLDENIMAGES/sunshine2.png -compose Src differences.png

  #pdftk golden.pdf burst output golden/golden_03%d.pdf
