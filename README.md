# 2021_AdlerMDS_MethodComparisonZlog

This is a RShiny based RMarkdown file for method comparison in the clinical laboratory. It uses standard regression methods like linear regression, Deming-regression and Passing-Bablok-regression.

It´s currently only usable with a a standard format of input .csv-files.

In order to standardize the measurements of both methods with respect to their reference intervals and thus to be able to reconcile the statement of the measurements by both methods with the clinical interpretation more easily, i use the zlog-values of the measurements as a new approach.

Here is the link to the "ready-to-use" RShiny-based Web-App: https://adlermds.shinyapps.io/AdlerMDS_MethodComparisonZlog/

You can run this WebApp on your local machine in a R Session using the following code:
```bash
library(shiny)
runGitHub("2021_AdlerMDS_MethodComparisonZlog", "Bussard91", ref = "main")
```

The theoretical basis is published in this Article: https://www.degruyter.com/document/doi/10.1515/labmed-2017-0135/html
