# files-renamer
A bash script to take a file of the format `[Tag] Name - ## [Resolution].ext` to `Name - ##.ext`

## How to use
`renameFiles.sh <num> <num>...` from the folder containing files to rename


A minimum of two numbers are required.  
The last number's value is appended after a `-` character.  
All of the files in the folder gets split along spaces and periods.  
`<num>` refers to the index of a word in the split file name.  
The extension is automatically re-appended to the name.
