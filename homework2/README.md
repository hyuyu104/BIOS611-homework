## Problem 1

We have often seen `-it` in invocations of Docker run. This kind of argument, where we have multiple letters after a single dash, is a convention which allows users to specify multiple short command line switches after a single dash. We could equivalently write `-i -t`. Consult the Docker documentation in whatever way you'd like and determine what `-i` and `-t` do.  Look up the history of the abbreviation "tty" and give a very brief (2-3 sentences) about its history and age. Compare this to a rough estimate of the length of time we've been sure that the world is composed of atoms.

### Answer

From the [documentation page](https://docs.docker.com/reference/cli/docker/container/run/), the `-i` option keeps the standard input open, and the `-t` attaches a pseudo-TTY to the container, where pseudo-TTY can be viewed as a pseudo-terminal in the container. In this way, after typing `docker run -ti`, one can use the original terminal to input commands to the container and get the output. TTY is the abbreviation for teletypewriter, which refers to any device that can send and receive pure text messages through various communication channels. The term emerged in 1887 in electrical telegraphy to automate the translation of Morse code. In 1950s, teletypewriters are connected to computers to receive and print messages. In modern computers, teletypewriters no longer physically print the message out, and they sometimes just refer to the terminals.

## Problem 2

Consider the R function `local`, used like so:
```R
z <- local({
 x<-10;
 y<-15;
 x + y;
})
```
Read the documentation on this function. Explain the difference between the above and this:
```R
z <- {
 x <- 10;
 y <- 15;
 x + y;
}
```

### Answer

The `local` function put all operations inside the function to a new environment. Thus in the first case, after defining `z`, both `x` and `y` are not in the global environment. However, in the second case, since the code is not wrapped by `local`, after defining `z`, there will also be two new variables `x` and `y`, with values `10` and `15`.

## Problem 3

Consider:
```R
list_of_functions <- list();
for(i in 1:10){
  list_of_functions <- c(list_of_functions, function() i);
}
for(f in list_of_functions){
  print(f());
}
```
Does the result surprise you? Why or why not? If the result surprised you, explain how to modify the code above such that it does what you expected it to do.

### Answer

The code prints 10 for ten times instead of 1, ..., 10 as we want. This is because in the first loop, it only adds the function reference to `list_of_functions`, not the actual values. When being called in the second loop, each `f` will try to find the value of `i`, which is 10 after the first loop completed. Therefore, all `f()`'s print `10`. To modify the code such that 1, ..., 10 is printed, we can change `list_of_functions <- c(list_of_functions, function() i);` to `list_of_functions <- c(list_of_functions, i);`, and the last print statement to `print(f)`.

## Problem 4

When we define a function and when we write a for loop or while loop we can use a "{}" block to indicate the body of either type of expression. The code inside two blocks can be identical but they nevertheless mean different things. Explain the difference.

### Answer

The "{}" in functions will create a separate environment, so all variables declared inside "{}" will not be available after the function is executed. However, all variables declared in a for loop or a while loop will be stored directly into the global environment, so they are available even when the loop finishes execution.

## Problem 5

Implement a function called "with_list" which accepts a list with named values and an expression which should be evaluated in an environment here the named values inside of the list can be referred to as regular variables. That is, it should work like this:
```R
q <- 7;
with_list(list(x=10,y=100),{
  x + y + q;
});
# x and y should be undefined here
```
Do your best to explain how your implementation works. Test it to make sure it does.

### Answer

Define the function `with_list` as
```R
with_list <- function(val_list, expr) {
  eval(substitute(expr), val_list)
}
```
When `{x + y + q}` is passed in, the function will not evaluate the argument directly. Instead, by wrapping it with `substitute`, the expression is passed into `eval`. Inside `eval`, a new environment with `val_list`'s values will be created, and now the expression `{x + y + q}` can see the value of `x` and `y` and return the correct sum.

## Problem 6

Consider:
```R
`%mid%` <- function(a,b) (a + b)/2;
z <- c(1,2,3) %mid% c(9,9,9)
z
```
What rule do we need to have in our mental model of R to make this work? Why did we have to put `%mid%` in backticks when we defined it? What should z be?

### Answer

An additional rule is that any expression flanked by `%` sign will be treated as a function, where the items that immediately precede and follow the expression will be used as inputs to the function. The `\`` sign ensures the first line is treated as variable definition; otherwise, according to our new rule, the expression will be viewed as a function and evaluated, which will throw an exception as it is not defined yet.

## Problem 7
We use a variety of package managers in this class. Briefly describe
each of the following:

1. apt
2. pip
3. install.packages

### Answer

`apt` is used to manage softwares on a linux machine. `pip` is specifically for python packages. `install.packages` is specific to R libraries and has to be run in an R environment. However, they are all package managers, so they can download and update packages and manage package dependencies. 

## Problem 8
For the next problem, you will probably want to be able to examine the
manual pages for common Linux commands. But when we run:

```bash
man ls
```

In our Rstudio Docker container, we see the following:

```
rstudio@2477943eb99a:~/work/lectures/02-unix$ man ls
This system has been minimized by removing packages and content that are not required on a system that users do not log into.
```

Create a Dockerfile based on `rocker/rstudio` or `rocker/verse` that
meets these requirements.

Hint: Here is how to use Ubuntu's package manager to install something
"the right way" in a Docker file:

```bash
RUN apt update && apt install -y <package-name> && rm -rf /var/lib/apt/lists/*
```

Hint: `unminimize` requires user interaction when you run it (it asks
if you actually want to do what the script does and wants you to type
"y"). We can't interact with programs in a Docker build step, but we
can use the utility "yes" to generate a 'yes' for us and pipe it into
`unminimize`.

## Problem 9
Write a bash script to compare the "man" pages for the following three
commands:

1. man
2. ls
3. find

The script should print out three lines, each with the command name,
followed by the number of lines in the man page for that command. The
lines should be in order by line count, descending.

Pro tips:
- You can redirect the output of a command to a file with ``>``, e.g.,
  `echo hi > ./some-file`. But this always deletes the file before
  writing the input to it. Use ``>>`` to append to the file (add
  content to the end).
- Feel free to Google stuff.
- You will need to use shell expansion, `echo`, `man`, `wc` (word
  count), and the utility `sort`. By default, `sort` uses lexical
  sorting on the whole line, but you can use the `-g` switch to enable
  numerical sorting, the `-k` switch to select a column (by number),
  the `-r` switch to sort descending, and the `-t` switch to select
  the delimiter, which is, in our case, a comma.

```bash
 > output.txt # clear the file first
for C in man ls find
do 
    echo "$C,$(man $C | wc -l | xargs)" >> output.txt
done
sort -g -k 2 -r -t "," < output.txt 
```

 
## Problem 10

Create your project.

This means:

1. pick a folder somewhere
2. Add a README.md that says "Hi, this is my 611 Data Science
   Project. More to come." in that directory.
3. Put the Dockerfile you created above into the directory.
4. Open up your terminal of choice
   cd <your-folder>
   git init
   git add -A: /
   git commit -m "First commit."
5. Go to github, sign up, create a new repository. Follow the
   instructions for associating that repository with the one in your
   folder.
6. Give us a link to the github page for your repo
