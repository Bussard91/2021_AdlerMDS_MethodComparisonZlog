# 2021_AdlerMDS_MethodComparisonZlog

In this repository my colleagues and I are developing an easy-to-use Shiny web App for method comparisons in the clinical laboratory.

The following workflow is to be illustrated:
- At least 5 samples covering the entire measuring range should be measured in duplicate. Even better is a 5-fold measurement of each sample to get an idea of the scatter of the two methods at the measuring points.
- In order to be able to select the correct regression method, the scatter for each method is determined for each measuring point on the basis of the 5-fold measurement.
- The ratio of the dispersion of the old method to the new method is formed from the dispersions.
- The regression method is selected depending on the scattering ratio:
  - ratio = 1 - orthogonal linear regression
  - ratio != 1 but approximately the same at all measuring points - simple Deming regression
  - ratio != 1 but different at each measuring point - generalized Deming regression
- A scatterplot is drawn with a reference line having a slope of 1 and an axis intercept of 0.
- The corresponding regression line is drawn.
- A Bland-Altman plot is drawn that looks at the absolute as well as the percentage deviations between the methods.
- The evaluation of the method comparison is carried out through various considerations:
  - If 1 is in the confidence interval of the slope of the line and 0 is in the confidence interval of the intercept of the line, the methods can be considered interchangeable.
  - Based on the work of [Haeckel et al.](https://www.degruyter.com/document/doi/10.1515/CCLM.2011.668/html) permissible performance limits of regression analyses are established. In the following, TOST (two one sided t-tests) are performed to test the significance of a deviation from the performance limits.
  - As a third possibility of verification, a new plot, the so-called "zlog plot", is introduced. In this plot, the measurement results of each method are converted into their zlog values using the respective reference intervals. Thus, the measurement results of both methods can be examined for interpretation with respect to the reference intervals. False-positive and false-negative findings can thus be compared with each other. The theoretical basis for zlog values is published in this [Article](https://www.degruyter.com/document/doi/10.1515/labmed-2017-0135/html).
  - As a last possibility of verification, the so-called reference change values should be considered. With the help of these "critical differences", it can be distinguished whether the differences between the methods are rather caused by a random error or a systematic deviation.
- All results are to be downloadable in a PDF report.

Critical review of the approach and R code is welcome.