%let path = .;  /* The base directory where you'd like to save outputs */
libname analysis "&path.\analysis"; /* NOTE: provide an EMPTY folder before running this macro */

/*standardization factor*/

* relative bias;

data mydata.relbias_sfactor_f; /*convert wide format to long format for frequentist results*/
    set mydata.relbias_sfactor_f;
    procedure = 1; sfactor_mean = rel_bias_RMSE_unc_mean; sfactor_median = rel_bias_RMSE_unc_median; output;
	procedure = 2; sfactor_mean = rel_bias_RMSE_chea_mean; sfactor_median = rel_bias_RMSE_chea_median; output;
    procedure = 3; sfactor_mean = rel_bias_sd_whino_unc_mean; sfactor_median = rel_bias_sd_whino_unc_median; output;
    procedure = 4; sfactor_mean = rel_bias_sd_whino_chea_mean; sfactor_median = rel_bias_sd_whino_chea_median; output;
    keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.relbias_sfactor_b_11;
	set mydata.relbias_sfactor_b_11;
	procedure = 5;sfactor_mean = rel_bias_sd_whino_mean; sfactor_median = rel_bias_sd_whino_median;output;
	procedure = 6;sfactor_mean = rel_bias_sd_resid_mean; sfactor_median = rel_bias_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.relbias_sfactor_b_12;
	set mydata.relbias_sfactor_b_12;
	procedure = 7;sfactor_mean = rel_bias_sd_whino_mean; sfactor_median = rel_bias_sd_whino_median;output;
	procedure = 8;sfactor_mean = rel_bias_sd_resid_mean; sfactor_median = rel_bias_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.relbias_sfactor_b_21;
	set mydata.relbias_sfactor_b_21;
	procedure = 9;sfactor_mean = rel_bias_sd_whino_mean; sfactor_median = rel_bias_sd_whino_median;output;
	procedure = 10;sfactor_mean = rel_bias_sd_resid_mean; sfactor_median = rel_bias_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.relbias_sfactor_b_22;
	set mydata.relbias_sfactor_b_22;
	procedure = 11;sfactor_mean = rel_bias_sd_whino_mean; sfactor_median = rel_bias_sd_whino_median;output;
	procedure = 12;sfactor_mean = rel_bias_sd_resid_mean; sfactor_median = rel_bias_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.relbias_sfactor_b_31;
	set mydata.relbias_sfactor_b_31;
	procedure = 13;sfactor_mean = rel_bias_sd_whino_mean; sfactor_median = rel_bias_sd_whino_median;output;
	procedure = 14;sfactor_mean = rel_bias_sd_resid_mean; sfactor_median = rel_bias_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.relbias_sfactor_b_32;
	set mydata.relbias_sfactor_b_32;
	procedure = 15;sfactor_mean = rel_bias_sd_whino_mean; sfactor_median = rel_bias_sd_whino_median;output;
	procedure = 16;sfactor_mean = rel_bias_sd_resid_mean; sfactor_median = rel_bias_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;


*MSE;

data mydata.mse_sfactor_f; /*convert wide format to long format for frequentist results*/
    set mydata.mse_sfactor_f;
    procedure = 1; sfactor_mean = mse_RMSE_unc_mean; sfactor_median = mse_RMSE_unc_median;output;
	procedure = 2; sfactor_mean = mse_RMSE_chea_mean; sfactor_median = mse_RMSE_chea_median;output;
    procedure = 3; sfactor_mean = mse_sd_whino_unc_mean; sfactor_median = mse_sd_whino_unc_median;output;
    procedure = 4; sfactor_mean = mse_sd_whino_chea_mean; sfactor_median = mse_sd_whino_chea_median;output;
    keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;


data mydata.mse_sfactor_b_11;
	set mydata.mse_sfactor_b_11;
	procedure = 5;sfactor_mean = mse_sd_whino_mean; sfactor_median = mse_sd_whino_median; output;
	procedure = 6;sfactor_mean = mse_sd_resid_mean; sfactor_median = mse_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.mse_sfactor_b_12;
	set mydata.mse_sfactor_b_12;
	procedure = 7;sfactor_mean = mse_sd_whino_mean; sfactor_median = mse_sd_whino_median; output;
	procedure = 8;sfactor_mean = mse_sd_resid_mean; sfactor_median = mse_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.mse_sfactor_b_21;
	set mydata.mse_sfactor_b_21;
	procedure = 9;sfactor_mean = mse_sd_whino_mean; sfactor_median = mse_sd_whino_median; output;
	procedure = 10;sfactor_mean = mse_sd_resid_mean; sfactor_median = mse_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.mse_sfactor_b_22;
	set mydata.mse_sfactor_b_22;
	procedure = 11;sfactor_mean = mse_sd_whino_mean; sfactor_median = mse_sd_whino_median; output;
	procedure = 12;sfactor_mean = mse_sd_resid_mean; sfactor_median = mse_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.mse_sfactor_b_31;
	set mydata.mse_sfactor_b_31;
	procedure = 13;sfactor_mean = mse_sd_whino_mean; sfactor_median = mse_sd_whino_median; output;
	procedure = 14;sfactor_mean = mse_sd_resid_mean; sfactor_median = mse_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;

data mydata.mse_sfactor_b_32;
	set mydata.mse_sfactor_b_32;
	procedure = 15;sfactor_mean = mse_sd_whino_mean; sfactor_median = mse_sd_whino_median; output;
	procedure = 16;sfactor_mean = mse_sd_resid_mean; sfactor_median = mse_sd_resid_median;output;
	keep gamma100 T rho sfactor_mean sfactor_median procedure;
run;



