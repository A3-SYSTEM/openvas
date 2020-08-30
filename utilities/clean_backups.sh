#
#
# 
for f in $(find . -name '*~' -type f); 
do 	 
	rm -fv $f 
done 

