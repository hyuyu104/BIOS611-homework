Submit this homework as an RMarkdown file and the additional files requested in part 7, please. The grader will download the data set when they grade, so you don't need to include it in your submission.

Download the NYC Dog Dataset (Click the "export" button).

https://data.cityofnewyork.us/Health/NYC-Dog-Licensing-Dataset/nu7n-tubp/about_data Links to an external site.

We will assume that the data set is located in the same directory as the Rmd file AND that it is the working directory.

1. Load the data into a tibble data frame and do the following things

    - print the "problems" data frame.

    - rename the columns so they are less redundant - we're only working with dogs here so we can use the column names: name, gender, birth_year, breed, zipcode, issue_date, expiration_date and extract_year.

    - You can rename columns in a lot of ways but I recommend using the function `rename` or the function `transmute` in this case. Look up the documentation to see how they work. Make sure you are looking at the documentation for the dplyr functions
    
    - reduce the data down to the complete cases without getting fancy about it. Make sure print out the row count before and after. You'll want to use the functions sprintf and cat. Both functions documentation will tell you how to use them.

2. Compare the number of distinct rows to the number of total rows. Print this out. Find the non-distinct rows and display them. In your RMarkdown file make some notes about the duplicate lines.

3. Use ggplot to graph the number of dogs born on a given year from the start of the data set. Then make a second plot restricted to years with a non-trivial number of dogs.

4. In lab we became aware of the fact that that we can't really identify unique dogs in this data set. The chance of two lines representing the same dog increases, however, if their name, gender, birth year, breed, and zip code are all the same. If we make this assumption, how many unique dogs are in the data set? Produce a filtered data set with unique dogs under the assumption. Print the row count before and after this assumption is enforced.

5. Create a new data frame which calculates the total number of dogs born on a give year and put it aside. Then calculate the total number of dogs with a given name on a given year in a second data frame. Do a join between the two and then calculate the rate of each dog name as a function of year. What is the most popular dog name in 1999? In 2024?

6. Create a plot showing the rate of the most popular dog name in 1999 over time. Create a second plot showing the popularity of the most popular dog name in 2024. Put both plots on the same figure.

7. When we do reproducible data scence we separate each step of our analysis into a separate script file which loads what it needs when it starts and saves its results on exit. Split this homework into as many scripts as you feel are appropriate and submit them along with this homework.

8. Create a makefile for this set of processing steps.