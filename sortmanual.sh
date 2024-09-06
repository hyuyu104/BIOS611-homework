 > output.txt # clear the file first
for C in man ls find
do 
    echo "$C,$(man $C | wc -l | xargs)" >> output.txt
done
sort -g -k 2 -r -t "," < output.txt 