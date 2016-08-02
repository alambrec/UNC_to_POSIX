# UNC to POSIX

This is a simple tutorial who explain how use `sed` command to migrate an UNC path to POSIX in each file.

## Introduction

Each ressources can be represented by either absolute or relative paths.

For now, there are two common syntax to describe the location of a network resource, such as a shared file, directory, or printer.

* **UNC (Uniform Naming Convention)**  
who is used only by Windows systems has a generic form : ``` \\ComputerName\SharedFolder\Resource ```

* **POSIX pathname definition**  
who is used by most Unix-like systems, including Windows : ``` smb://hostname/directorypath/resource ```


Well, you probably understood that the best choice is used the most often POSIX convention in your different project to minimize several incompatibility between each systems.


## The principe
```sed``` (Stream EDitor) is a Unix utility that parses and transforms text. The main concept of ```sed``` command is that permit to edit only line per line a file or ```STDOUT```. If you want edit a full file, you must use ```awk``` command. 

In short, if you want apply the same substition on each line of a specific file, you must use ```sed```, on contrary, if you want apply the same modification on many file, you must use ```awk```.


## Sample 1
I'm a Kodi fan and I use a program for manage localy my big library of Video and TV Shows. Badly, my internet connection is too bad to research metadata of movies. I use `MetaBrowser <2.0>` who permit to dump all metadata of my library and save it in `*.nfo` file.

But I have a several problem on the viewing of thumbnail. The problem was the thumbnail path in NFO file who was written in UNC convention, or my client was running under Linux. I must to change each UNC path to POSIX path in all `*.nfo` files. 

So, in short, I want make it :
`\\192.168.1.110\media\ImageByName\J\Jennifer Lawrence\folder.jpg`  
to  
`smb://NAS/MEDIA/ImageByName/J/Jennifer Lawrence/folder.jpg`

So, I use `sed` to make this substitution :
`sed -E -i.bak 's=\\\\192.168.1.110\\media\\ImageByName\\(.*)\\(.*)\\(.*)=smb:\//NAS\/MEDIA\/ImageByName\/\1\/\2/\3='`

And I use `find` command to apply on all files with `.nfo` extensions
```
find . -name "*.nfo" -exec sed -E -i.bak 's=\\\\192.168.1.110\\media\\ImageByName\\(.*)\\(.*)\\(.*)=smb:\//NAS\/MEDIA\/ImageByName\/\1\/\2/\3=' {} \;
```

### How it work ?
* `-E` enable regular expressions (on OSX, if you are on Linux, you must use `-e`) 
* `-i.bak` it's mandatory. Replace the content of file and make a backup file before with `.bak` extensions.
* `=`is the separator : `s=$FIND=$REPLACE`
* `\\\\192.168.1.110\\media\\ImageByName` is my pattern, it's common ! You must insert `\` before each `\` because it's special character
* `\\(.*)\\(.*)\\(.*)` store in dictionary the content between `\content\`  
For example, with `\J\Jennifer Lawrence\folder.jpg`, there will be in dictionary 3 elements who corresponding at `\1`, `\2` and `\3`.  
	* `\1` = `J`
	* `\2` = `Jennifer Lawrence`
	* `\3` = `folder.jpg`
* `smb:\//NAS\/MEDIA\/ImageByName` is my new string, common on every files
* `\1\/\2/\3`is equal to `|content of \1| / |content of \2| / |content of \3|`. Finnaly, is equal to, `J/Jennifer Lawrence/folder.jpg`
