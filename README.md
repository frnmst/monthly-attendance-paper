# monthly-attendance-paper

A simple bash script that generates a monthly printout calendar template to be 
used between an employer and employee.

## Dependencies 

All of them should be already installed in your system:

- [GNU Bash](http://www.gnu.org/software/bash/bash.html)
- [Coreutils](https://www.gnu.org/software/coreutils/)
- [Gawk](http://www.gnu.org/software/gawk/)
- [util-linux](https://www.kernel.org/pub/linux/utils/util-linux/)

Optionally, to print the template:

- [CUPS](http://www.cups.org/)

or whatever printing system is able to print from the 
standard input

## Configuration

Edit `configrc` based on your needs. 
variable names are self-explanatory.

Important variables are:

    this_month
    this_year
    employer
    employee

as well as the days of the week, which you can translate in
your language.

You can also edit the date formats in the following functions:

    get_full_string()
    print_day()

## Running

    $ ./monthly_attendace_paper.sh

## Printing

    $ ./monthly_attendace_paper.sh | lpr

## Warning

This script does not check any input nor output for errors. 
That's up to you.

## License

CC0.

