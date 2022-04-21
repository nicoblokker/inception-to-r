Importing Inception’s export into R
================

## Introduction

-   *Goal:* extract annotations from
    [Inception’s](https://inception-project.github.io/) (Klie et
    al. 2018) XMI-export into R for further analysis
-   *`inception2r`* lets the user filter the exported files to extract
    only desired variables
-   *Intuition:* sometimes the user is only interested in specific
    features from the export (e.g., custom annotations) and not the
    whole overhead
-   *under the hood:* the package makes heavy use of the `xml2` package
    (Wickham, Hester, and Ooms 2021) to extract XML-elements from
    exported files
-   *how does it work:*
    -   in a first step, `inception2r` lets the user define namespaces
        (features and layers) via simple XML-path language
    -   in a second step, it extracts both xml-attributes and
        xml-content (nodes and names) of the defined feature
    -   finally, it returns a `data.frame` containing only the queried
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

-   download/export file(s) from Inception
-   run `unzip_export` to unzip all (.zip) files in the specified
    directory labeled as “webanno…” and place in new folder
    -   can be applied both to individual documents and
    -   to the complete export (set `recursive = TRUE` to extend towards
        sub-directories)

``` r
unzip_export(path_to_export = ".", overwrite = FALSE, recursive = FALSE)  # CREATES LOCAL FILES; USE WITH CAUTION 
xmi_file <- list.files(".", pattern = "\\.xmi$", recursive = T)           # select only XMI-files
xmi_file
```

    ## [1] "extracted/example_txt.xmi"

## Extract annotations

-   use `xmi2df` function to extract annotations specified by the `key`
    argument (defaults to “custom”)
-   Note: `key` queries the string contained in namespaces (e.g.,
    “custom” matches “custom” AND “custom2”)

``` r
# extract custom annotations from file
df_custom <- xmi2df(xmi_file, key = "custom")
print(df_custom, n = 5)
```

    ## # A tibble: 50 x 14
    ##   id    sofa  begin end   Akteur Frame Polarity Wiedervorlage layer       text  
    ##   <chr> <chr> <chr> <chr> <chr>  <chr> <chr>    <chr>         <chr>       <chr> 
    ## 1 5881  1     0     84    6024   6075  -        false         Claim_multi 207 S~
    ## 2 6121  1     155   292   6604   6264  -        false         Claim_multi 207 S~
    ## 3 6650  1     429   599   6793   6844  -        false         Claim_multi 207 S~
    ## 4 6973  1     783   979   7122   7173  -        false         Claim_multi 207 S~
    ## 5 7302  1     1125  1230  7445   7496  -        false         Claim_multi 207 S~
    ## # ... with 45 more rows, and 4 more variables: filename <chr>, role <chr>,
    ## #   target <chr>, quote <chr>

### Extract annotations from multiple documents (and namespaces)

-   include several namespaces or tags (layers also work,
    e.g. “Statement”)
-   iterate over multiple files and add index as new column (`file`)
    using the `purrr` package

``` r
# extract multiple layers
df_mult_layers <- xmi2df(xmi_file, key = c("custom", "Sentence")) 

# extract multiple files (and layers)
df_mult_files <- purrr::map_df(c(xmi_file, xmi_file), xmi2df, key = c("custom", "Sentence"), .id = "file")
```

-   to see what namespaces are available run `select_ns`

``` r
select_ns(xmi_file)
```

    ##  [1] "cas"         "chunk"       "constituent" "custom"      "custom2"    
    ##  [6] "dependency"  "morph"       "pos"         "tcas"        "tweet"      
    ## [11] "type"        "type10"      "type2"       "type3"       "type4"      
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
