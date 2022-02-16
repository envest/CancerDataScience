# Command line

There are several places to interact with the command line.
You can access the terminal on your computer, within RStudio, or play around in Terminal Basics on [sandbox.bio](sandbox.bio).

Here is a running list of commands we have learned so far:

| command | some options | what it does | example |
| ------- | ------- | ------------ | ------- |
| `cat` | | con`cat`enate files,<br />or just print out one file | `cat file1.tsv file2.tsv`<br />`cat results.tsv` |
| `cd` | | `c`hange `d`irectory<br />(move to new location in file system) | `cd new_directory` |
| `cp` | | copy a file | `cp original_file.tsv new_file.tsv`
| `grep` | `-i` ignore case<br />`-v` invert match | print lines that match a pattern | `grep TP53 cancer_genes.tsv` |
| `head` | `-n` number of lines | print the first lines of a file | `head -n 12 my_file.tsv ` |
| `echo` | | Print a string to the screen | `echo hi!` |
| `ls` | `-l` long format<br />`-h` human readable format | List files and folders in a directory | `ls -lh`<br />`ls subfolder` |
| `mkdir` | | make a new directory | `mkdir new_directory` |
| `pwd` | | `p`rint `w`orking `d`irectory<br />(your current location in file system) | `pwd` |
| `rm` | `-i` interactive (asks yes/no)<br />`-r` recursive, for removing directories | remove a file(s) -- be careful!<br >`rm` is permanent (no trash bin) | `rm old_file.tsv` |
| `tail` | `-n` number of lines | print the last lines of a file | `tail -n 3 my_file.tsv` |
| `wc` | `-l` count lines | `w`ord `c`ount<br />mostly used for counting number of lines | `wc -l cancer_genes.tsv` |

In addition to commands, there are command line operators:

| operator | what it does | example |
| -------- | ------------ | ------- |
| `>` | save output to a file | `grep RAS cancer_genes.tsv > cancer_genes_with_RAS.tsv` |
| `\|` | "the pipe" lets output from one command flow<br />downstream to be input to the next command | `cat gene_list1.tsv gene_list2.tsv \| grep oncogene` |
| `=` | assign a value to a variable | `favorite_gene=NTRK1`<br />`echo $favorite_gene` |


To learn more about each command, read the manual using `man` or google it!
`man` is not available on sandbox.bio but it is available in Terminal, Rstudio, etc.
For example, to read the official documentation for all options for the `ls` command, type in `man ls`.
Or, again, use google to search for your specific question, something like "list all files from newest to oldest".
