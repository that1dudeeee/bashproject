
#!bin/bash

sed -n 's/.*from\([0-9.]*\)/\1/p' test.tct #GETS IP ADRESS
sed 's/error/WARNING/' test.tct #CHANGE ERROR WITH WARNING
sed 's/user[0-9]/REDIRACTING/g' test.tct #SIMUALE REDACTING SENSTIVE INFO
sed 's/^\(\S\+\s\+\S\+\s\+\S\+\).*/\1/' test.tct #keeps only first 3 words per line
sed = test.tct | sed 'N;s/\n/: /' #add lines numbers before each line
sed '/failed/ s/$/ [CHECL THIS]/' test.tct #appends warning to failed attempts
sed 's/^/%y-%m-%day /' test.tct #yk what this does bruh
sed 's/[[:space:]]\+$//' test.tct

