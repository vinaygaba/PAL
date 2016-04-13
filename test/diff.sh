#!/bin/bash
OUTPUT=output/*
GOLDEN=golden/*
OUTPUTIMAGES1=output/images/
GOLDENIMAGES1=golden/images/

OUTPUTIMAGES2=output/images/*
GOLDENIMAGES2=golden/images/

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

sleep 7;

for o in $OUTPUTIMAGES2
do
    if [ ${o##*.} == png ]
      then
    #echo ${o##*/}
    compare ${o} $GOLDENIMAGES1${o##*/} -compose Src differences.png
    fi
done
#compare $OUTPUTIMAGES/sunshine1.png $GOLDENIMAGES/sunshine2.png -compose Src differences.png

  #pdftk golden.pdf burst output golden/golden_03%d.pdf
