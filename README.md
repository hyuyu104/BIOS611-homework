Hi, this is my 611 Data Science Project. More to come.

---

For this and any homework assignment, feel free to actually type code
in and run it.

## Problem 1
Suppose you run this code.

```bash
alias hello="echo hello world"
hello
```

Given that "hello" isn't a file on the path, describe how to modify
your "evaluation strategy" to account for this new behavior.

### Answer:

The current evaluation strategy goes like:

1. Input: read the string user typed (standard input)
2. Tokenization
    1. Pre-tokenize the input on “|”
    2. Tokenize the input on spaces
3. Shell expansion: replace any token starting with $ by their values
4. Evaluate the first token
    1. If it has the form “NAME=VAL”, then add the variable to the environment
    2. If it is an executable in $PATH, run the executable along with all arguments
    3. Otherwise, throw error “command not found”
5. Look for < or >, attach to standard input or standard output

As the code above does execute the command `echo hello world` when `hello` was typed in, there should be an additional step when evaluating the first token. One possibility is that there is a separate namespace for `alias`, so when evaluating the first token, shell also searches within this namespace in addition to the `$PATH` variable, and if it found a variable with the same name, shell will treat the value it stored as the command to execute.

## Problem 2
Execute the following code:

```bash
alias zz=zz
zz
```

Does this produce an error message? If it does, what can you conclude
about how `alias` works?

### Answer:

The code does give a "command not found" error. This shows that the the same command in alias is only expanded once (expanded once means finding the definition in alias). Otherwise, since `zz` is defined to be itself, shell will trace down the definition forever and keep expanding the command, and no message will be returned. This can also be further verified by replacing `zz` with `ls`, which listed all files in the directory and did not throw any error.

```bash
alias aa=bb
alias bb=aa
aa
```

Given what we have learned above (and without running the code\*),
what do you expect this to do?

\* You can always run the code, but try to figure this out without
doing so.

### Answer:

After defining `aa=bb` and `bb=aa`, the command `aa` will still refer to the same `aa` at the beginning since when tracing the aliases, shell first sees that `aa` is defined as `bb`, so now `aa` is `bb`, and then shell sees `bb` is defined as `aa`, now `aa` is `aa` again. The important part is now shell stops to trace the alias anymore as `aa` is already expanded once. Therefore, `aa` will be defined as just `aa` as before.

## Problem 3
Create a file called "experiment.sh" that looks like this:

```bash
#!/bin/bash
echo "argument number one is $1"
echo "argument number two is $2"
echo "rest of the arguments ${@:3}"
echo "all arguments $@"
```

And invoke it by saying:

```bash
chmod u+x ./experiment.sh
./experiment.sh a b c d e
```

Describe some new evaluation rules that explain this
behavior. Experiment! You don't need to get this exactly right.

### Answer:

It seems that all the tokens after the first one are stored as environment variables with names `1`, `2`, `3`, etc. Thus the command in `./experiment.sh` can print the arguments. This step happens before evaluating and running the first token but after the shell expansion step as shown in the following example:

```bash
(base) homework1 % a="iofwjoeijf"
(base) homework1 % ./experiment.sh $a b c d e
argument number one is iofwjoeijf
argument number two is b
rest of the arguments c d e
all arguments iofwjoeijf b c d e
```

where the value of `a` is already replaced with its definition.

## Problem 4
The first line of the above script (`#!/bin/bash`): what do you
imagine it does, if anything? What is its purpose? Feel free to Google
this one or consult some kind of robot.

### Answer

As it contains `bin/bash`, it probably tells shell that this script should be run with bash. Indeed, it is called a "shebang" and serves mainly to tell the operating system how to run this script. Additionally, with `#!/bin/bash`, the program can be run without specifying `sh /.SCRIPT.sh`.

## Problem 5
Invoke the script like this:

```bash
bash ./experiment.sh a 'b c' d
```

Describe a new evaluation rule to explain the results.

### Answer

`b c` is treated as a single argument instead of two arguments: `b` and `c`. This shows that tokenization won't cut at spaces within a pair of quotation marks. In summary, after problem 1-5, we have the following updated evaluation rule:

1. Input: read the string user typed (standard input)
2. Tokenization
    1. Pre-tokenize the input on quotation marks
    2. Pre-tokenize the input on “|”
    3. Tokenize the input on spaces
3. Shell expansion: replace any token starting with $ by their values
    - Store all tokens/arguments as environment variables
4. Evaluate the first token
    1. If it has the form “NAME=VAL”, then add the variable to the environment
    2. If it is an executable in $PATH or an alias, run the executable along with all arguments
    3. Otherwise, throw error “command not found”
5. Look for < or >, attach to standard input or standard output

## Problem 6
Reading documentation is very important for technical work, and we
ought not be intimidated by it. Thus, examine the Docker documentation
and explain to me the difference between `RUN` and `CMD` lines in a
Dockerfile.

### Answer

Comands after `RUN` will be executed during the building process of a Docker image. In contrast, commands preceded by `CMD` will be run when an image is available and a Docker container is started from the image. To be more specific, when the image is already built once with `docker build`, the next time the user run `docker build`, commands preceded by `RUN` will not be executed while the command after `CMD` will be executed. Moreover, only the last `CMD` command will be executed while all `RUN` statements will be executed.

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





