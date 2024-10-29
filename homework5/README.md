

```sh
docker build . -t hw5
docker run --rm -ti -e PASSWORD=yourpassword -v $(pwd):/home/rstudio/work -p 8787:8787 hw5
```

1. What the code does

`md5_hash`: returns a unique code for each url page fetched.

`cache_path`: returns a unique path for each url by calling the `md5_hash` function.

`fetch_raw`: use the `requests` module to fetch webpage content of a given url. Will return the text on the webpage if the request is successful (status code is 200); otherwise will return None. To avoid overcrowding the server with too many simultaneous requests, each request is randomly delayed for 6 to 12 seconds.

`fetch`: for a given url, first check whether it is already downloaded before with file name given by `md5_hash(url)`. If so, will read from the saved file and return a `BS` object. Otherwise, will call the `fetch_raw` function to obtain the contents and return a `BS` object.

`episode_list_urls`: get all the individual urls from the webpage [http://www.chakoteya.net/NextGen/episodes.htm](http://www.chakoteya.net/NextGen/episodes.htm).

`tokenize_and_count`: process the text by 1) removing punctuation and downcasing, 2) tokenize the text using the `word_tokenize` function from `nltk`, 3) remove `stop_words` defined by `nltk`, and 4) count the word frequencies in the filtered tokens.

`get_text_of_episodes`: download texts from each url returned by `episode_list_urls` and append it to a Python list. Each list element is a dictionary with two attributes: url and text.

`get_word_counts_for_episodes`: the input `episode` is from `get_text_of_episodes`. For each dictionary in `episode`, call the `tokenize_and_count` function to process the text and append the word count to a new dictionary, with key being the corresponding url.

`get_total_word_count`: count the presence of each word in all episodes. Achieved by updating the `Counter` object with word counts of each episode.

`convert_to_word_count_vectors`: for word counts from an episode webpage, convert it to a vector, with the ith entry corresponding to the number of presence of the word `filtered_words[i]`.

`write_word_counts_to_csv`: write the vector for each url into a csv file. Each row corresponds to a url.