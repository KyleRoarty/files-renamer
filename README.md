# files-renamer
A bash script to take a file of the format `[Tag] Name - ## [Resolution].ext` to `Name - ##.ext`

## How to use
`renameFiles.sh <num> <num>...`


A minimum of two numbers are required.  
The last number's value is appended after a `-` character.  
`[Tag] Name - ## [Resolution].ext` gets split along spaces and periods.  
`<num>` refers to the index of a word in the array of the split title.  
The extension is automatically appended to the name.
