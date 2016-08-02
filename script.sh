sed -E -i.bak 's=\\\\192.168.1.110\\media\\ImageByName\\(.*)\\(.*)\\(.*)=smb:\//NAS\/MEDIA\/ImageByName\/\1\/\2/\3=' test_file.nfo

sed -E 's=\\\\Nas\\media\\ImageByName\\([A-Z])([a-z].*)\\(.*)=smb:\//NAS\/MEDIA\/ImageByName\/\1/\1\2\/\3='

find . -name "*.nfo" -exec sed -E -i.bak 's=\\\\192.168.1.110\\media\\ImageByName\\(.*)\\(.*)\\(.*)=smb:\//NAS\/MEDIA\/ImageByName\/\1\/\2/\3=' {} \;

find . -name "*.nfo" -exec sed -E -i.bak 's=\\\\Nas\\media\\ImageByName\\([A-Z])([a-z].*)\\(.*)=smb:\//NAS\/MEDIA\/ImageByName\/\1/\1\2\/\3=' {} \;

find . -name "*.nfo.bak" -exec rm -f {} \;
