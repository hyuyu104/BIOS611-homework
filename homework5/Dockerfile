FROM rocker/rstudio

RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab requests bs4 nltk
RUN python -c "import nltk; nltk.download('punkt_tab')"

RUN R -e "install.packages(c('gbm', 'pROC'))"