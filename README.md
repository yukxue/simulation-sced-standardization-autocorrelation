# simulation-sced-standardization-autocorrelation

## Simulation code

"model_bf_s1.sas" contains: 
(1) SAS code to simulate raw data; 
(2) code to run an external SAS code that generates and launches the OpenBUGS program for Bayesian estimation; the external SAS code is revised from Smith (2008), and can be provided upon request.
(3) code to fit linear models with AR(1) residuals using REML.

## Analysis code (four steps)

"1.1 stat_properties_freq_S1.sas": calculate the statistical properties for REML estimates

"1.2 stat_properties_baye_S1": calculate the statistical properties for Bayesian estimates

"2.1 add procedure (intervention and autocorrelation)": add the variable "procedure" to the REML estimates

"2.2 add procedure (standardization factor)": add the variable "procedure" to the Bayesian estimates

"3 merge freq and Baye": merge the estimates of REML and Bayesian methods into one dataset

"4 GLM analysis_bf_S1": run GLM analysis to examine the impacts of design factors/estimation procedures on the statistical properties

## Contact: xyukang@gmail.com.

**References**

Smith, M. K. (2008). WinBUGSio: A SAS macro for the remote execution of WinBUGS. *Journal of Statistical Software, 23*, 1-10. https://doi.org/10.18637/jss.v023.i09
