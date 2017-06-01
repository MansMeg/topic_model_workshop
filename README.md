# A one day topic model workshop

This repository contain everything needed for the topic modeling workshop in Umeå, june 2017. You can either just follow the knitty-gritty details of fiting a topic model or try to do it yourself. If you want to do it yourself, you need to download the material and install the software below.

## Get the material for the workshop

The easiest way is just to either clone the repository (for those who knows git) or just click on the green button "Clone or Download" -> "Download as ZIP".

## Installation / software

To be able to follow everything in detail, you would need to have R and R-Studio installed. You can find R [here](https://cran.r-project.org/) and R-Studio [here](https://www.rstudio.com/). It is all open source.

In R we will use a couple of package for text handling. To install it, open R-Studio and in the console run:

```
install.packages("devtools")
install.packages("tidytext")
install.packages("dplyr")
install.packages("stringr")
```

We will also need a development version of the RMallet package.

```
devtools::install_github("MansMeg/RMallet", subdir = "mallet")
```

It should look something similar to this:

```
Downloading GitHub repo MansMeg/RMallet@master
from URL https://api.github.com/repos/MansMeg/RMallet/zipball/master
Installing mallet
trying URL 'https://cran.rstudio.com/bin/macosx/mavericks/contrib/3.3/rJava_0.9-8.tgz'
Content type 'application/x-gzip' length 612168 bytes (597 KB)
==================================================
  downloaded 597 KB

Installing rJava
'/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file --no-environ  \
--no-save --no-restore --quiet CMD INSTALL  \
'/private/var/folders/9h/yf354vb917z6gr6mz7bfb1d40000gn/T/RtmpWlT3nH/devtools808f42ecebf4/rJava'  \
--library='/Library/Frameworks/R.framework/Versions/3.3/Resources/library'  \
--install-tests 

* installing *binary* package ‘rJava’ ...
* DONE (rJava)
'/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file --no-environ  \
--no-save --no-restore --quiet CMD INSTALL  \
'/private/var/folders/9h/yf354vb917z6gr6mz7bfb1d40000gn/T/RtmpWlT3nH/devtools808f6e859805/MansMeg-RMallet-2531db3/mallet'  \
--library='/Library/Frameworks/R.framework/Versions/3.3/Resources/library'  \
--install-tests 

* installing *source* package ‘mallet’ ...
** R
** data
*** moving datasets to lazyload DB
** inst
** tests
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** installing vignettes
** testing if installed package can be loaded
* DONE (mallet)
```

Test that everything work by loading the mallet package.

```
library(mallet)
```

