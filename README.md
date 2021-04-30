# monthly-attendance-paper

A simple bash script that generates a monthly printout calendar template to be 
used between an employer and employee.

**Warning: THIS REPOSITORY IS DEPRECATED. HAVE A LOOK HERE:**

- https://software.franco.net.eu.org/frnmst/automated-tasks
- https://codeberg.org/frnmst/automated-tasks
- https://github.com/frnmst/automated-tasks
- https://docs.franco.net.eu.org/automated-tasks/scripts.html#monthly-attendance-paper-py

## Table of contents

<!--TOC-->

- [monthly-attendance-paper](#monthly-attendance-paper)
  - [Table of contents](#table-of-contents)
  - [Dependencies](#dependencies)
  - [Example](#example)
  - [Configuration](#configuration)
  - [Running](#running)
  - [Printing](#printing)
  - [Warning](#warning)
  - [License](#license)

<!--TOC-->

## Dependencies

| Package name | Version | Required |
|--------------|---------|----------|
| [GNU Bash](http://www.gnu.org/software/bash/bash.html) | 5.0.011(1) | yes |
| [Coreutils](https://www.gnu.org/software/coreutils/) | 8.31 | yes |
| [Gawk](http://www.gnu.org/software/gawk/) | 5.0.1 | yes |
| [util-linux](https://www.kernel.org/pub/linux/utils/util-linux/) | 2.34 | yes |
| [CUPS](http://www.cups.org/) | 2.3.0 | no |

## Example

See [example.txt](example.txt) for an example printout. Note 
that the example was made to test a leap year.

## Configuration

Edit the `./configrc` file based on your needs. 
Variable names are self-explanatory.

You can also edit the date formats in the following script functions:

    get_full_string()
    print_day()

## Running

    $ ./monthly_attendace_paper.sh ./configrc

## Printing

    $ ./monthly_attendace_paper.sh ./configrc | lpr

## Warning

This script heavily depends on tabs for formatting. What you see
in a printout may be different to what you see on the screen;
what you see on an editor after executing:

    $ ./monthly_attendace_paper.sh ./configrc > printout.txt

might be different than:

    $ ./monthly_attendace_paper.sh ./configrc

This script does not check any input nor output for errors. 
That's up to you.

## License

CC0.

