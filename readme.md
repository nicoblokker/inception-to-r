Importing Inception’s export into R
================

<!-- badges: start -->

[![R-CMD-check](https://github.com/nicoblokker/inception-to-r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nicoblokker/inception-to-r/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Introduction

- *Goal:* extract annotations from
  [Inception’s](https://inception-project.github.io/) (Klie et al. 2018)
  XMI-export into R for further analysis
- *`inception2r`* lets the user filter the exported files to extract
  only desired variables
- *Intuition:* sometimes the user is only interested in specific
  features from the export (e.g., custom annotations) and not the whole
  overhead
- *under the hood:* the package makes heavy use of the `xml2` package
  (Wickham, Hester, and Ooms 2021) to extract XML-elements from exported
  files
- *how does it work:*
  - in a first step, `inception2r` lets the user define namespaces
    (features and layers) via simple XML-path language
  - in a second step, it extracts both xml-attributes and xml-content
    (nodes and names) of the defined feature
  - finally, it returns a `data.frame` containing only the queried
    variables and corresponding text spans

## Setup

### Installation

``` r
remotes::install_github("nicoblokker/inception-to-r")
```

### Load package and unzip XMI-files

``` r
library(inception2r)
```

*\[skip this step if XMI-files are already unzipped\]*

- download/export file(s) from Inception[^1]
- run `unzip_export` to unzip all (.zip) files in the specified
  directory labeled as “annotation…” or “curation…” and place in new
  folder
  - can be applied both to individual documents and
  - to the complete export (set `recursive = TRUE` to extend towards
    sub-directories)

``` r
unzip_export(folder = "export", overwrite = FALSE, recursive = FALSE)     # CREATES LOCAL FILES; USE WITH CAUTION 
xmi_file <- list.files(".", pattern = "\\.xmi$", recursive = T)           # select only XMI-files
xmi_file
```

    ## [1] "tests/testthat/annotation/test_document.txt/extracted/demo.xmi"

## Extract annotations

- use `xmi2df` function to extract annotations specified by the `key`
  argument (defaults to “custom”)
- Note: `key` queries the string contained in namespaces (e.g., “custom”
  matches “custom” AND “custom2”)

``` r
# extract custom annotations from file
df_custom <- xmi2df(xmi_file, key = "custom")
print(df_custom, n = 3)
```

    ## # A tibble: 3 × 9
    ##   id    sofa  begin end   label   layer         text  xmi_file_name        quote
    ##   <chr> <chr> <chr> <chr> <chr>   <chr>         <chr> <chr>                <chr>
    ## 1 4075  1     213   295   Label 1 SentenceLabel ""    tests/testthat/anno… " St…
    ## 2 4085  1     748   804   Label 2 SentenceLabel ""    tests/testthat/anno… " At…
    ## 3 4080  1     805   887   Label 1 SentenceLabel ""    tests/testthat/anno… " St…

### Extract annotations from multiple documents (and namespaces)

- include several namespaces or tags (layers also work,
  e.g. “Statement”)
- iterate over multiple files and add index as new column (`file`) using
  the `purrr` package

``` r
# extract multiple layers
df_mult_layers <- xmi2df(xmi_file, key = c("custom", "Sentence")) 

# extract multiple files (and layers)
df_mult_files <- purrr::map_df(c(xmi_file, xmi_file), xmi2df, key = c("custom", "Sentence"), .id = "file")
```

- to see what namespaces are available run `select_ns`

``` r
select_ns(xmi_file)
```

    ##  [1] "cas"         "chunk"       "constituent" "custom"      "dependency" 
    ##  [6] "morph"       "pos"         "tcas"        "tweet"       "type"       
    ## [11] "type10"      "type11"      "type2"       "type3"       "type4"      
    ## [16] "type5"       "type6"       "type7"       "type8"       "type9"      
    ## [21] "xmi"

#### References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-inception" class="csl-entry">

Klie, Jan-Christoph, Michael Bugert, Beto Boullosa, Richard Eckart de
Castilho, and Iryna Gurevych. 2018. “The INCEpTION Platform:
Machine-Assisted and Knowledge-Oriented Interactive Annotation.” In
*Proceedings of the 27th International Conference on Computational
Linguistics: System Demonstrations*, 5–9. Santa Fe, USA: Association for
Computational Linguistics.
<http://tubiblio.ulb.tu-darmstadt.de/106270/>.

</div>

<div id="ref-xml2" class="csl-entry">

Wickham, Hadley, Jim Hester, and Jeroen Ooms. 2021. *Xml2: Parse XML*.
<https://CRAN.R-project.org/package=xml2>.

</div>

</div>

[^1]: Demo project used in this repository created by:
    <https://morbo.ukp.informatik.tu-darmstadt.de/demo>
