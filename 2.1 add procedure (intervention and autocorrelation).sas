%let path = .;  /* The base directory where you'd like to save outputs */
libname analysis "&path.\analysis"; /* NOTE: provide an EMPTY folder before running this macro */

*relative bias;

data mydata.relbias_f; /*convert wide format to long format for frequentist results; this is to include both frequentist estimation of corrected and uncorrected rho into glm analysis*/
    set mydata.relbias_f;
    procedure = 1; rel_bias_rho_comp = rel_bias_rho_chea_adj_Mean; output;
    procedure = 8; rel_bias_rho_comp = rel_bias_rho_unc_Mean; output;
run;

data mydata.relbias_beta1_11;
	set mydata.relbias_beta1_11;
	procedure = 2;
run;

data mydata.relbias_rho_11;
	set mydata.relbias_rho_11;
	procedure = 2;
run;

data mydata.relbias_beta1_12;
	set mydata.relbias_beta1_12;
	procedure = 3;
run;

data mydata.relbias_rho_12;
	set mydata.relbias_rho_12;
	procedure = 3;
run;

data mydata.relbias_beta1_21;
	set mydata.relbias_beta1_21;
	procedure = 4;
run;

data mydata.relbias_rho_21;
	set mydata.relbias_rho_21;
	procedure = 4;
run;

data mydata.relbias_beta1_22;
	set mydata.relbias_beta1_22;
	procedure = 5;
run;

data mydata.relbias_rho_22;
	set mydata.relbias_rho_22;
	procedure = 5;
run;

data mydata.relbias_beta1_31;
	set mydata.relbias_beta1_31;
	procedure = 6;
run;

data mydata.relbias_rho_31;
	set mydata.relbias_rho_31;
	procedure = 6;
run;

data mydata.relbias_beta1_32;
	set mydata.relbias_beta1_32;
	procedure = 7;
run;

data mydata.relbias_rho_32;
	set mydata.relbias_rho_32;
	procedure = 7;
run;

*mse;

data mydata.mse_f; /*convert wide format to long format for frequentist results; this is to include both frequentist estimation of corrected and uncorrected rho into glm analysis*/
    set mydata.mse_f;
    procedure = 1; mse_rho_comp = mse_rho_chea_adj_Mean; output;
    procedure = 8; mse_rho_comp = mse_rho_unc_Mean; output;
run;

data mydata.mse_beta1_11;
	set mydata.mse_beta1_11;
	procedure = 2;
run;

data mydata.mse_rho_11;
	set mydata.mse_rho_11;
	procedure = 2;
run;

data mydata.mse_beta1_12;
	set mydata.mse_beta1_12;
	procedure = 3;
run;

data mydata.mse_rho_12;
	set mydata.mse_rho_12;
	procedure = 3;
run;

data mydata.mse_beta1_21;
	set mydata.mse_beta1_21;
	procedure = 4;
run;

data mydata.mse_rho_21;
	set mydata.mse_rho_21;
	procedure = 4;
run;

data mydata.mse_beta1_22;
	set mydata.mse_beta1_22;
	procedure = 5;
run;

data mydata.mse_rho_22;
	set mydata.mse_rho_22;
	procedure = 5;
run;

data mydata.mse_beta1_31;
	set mydata.mse_beta1_31;
	procedure = 6;
run;

data mydata.mse_rho_31;
	set mydata.mse_rho_31;
	procedure = 6;
run;

data mydata.mse_beta1_32;
	set mydata.mse_beta1_32;
	procedure = 7;
run;

data mydata.mse_rho_32;
	set mydata.mse_rho_32;
	procedure = 7;
run;

*std;

data mydata.std_f; /*convert wide format to long format for frequentist results; this is to include both frequentist estimation of corrected and uncorrected rho into glm analysis*/
    set mydata.std_f;
    procedure = 1; rel_biasdif_rho_comp = rel_biasdif_rho_chea_adj_Mean; output;
    procedure = 8; rel_biasdif_rho_comp = rel_biasdif_rho_unc_Mean; output;
run;

data mydata.std_beta1_11;
	set mydata.std_beta1_11;
	procedure = 2;
run;

data mydata.std_rho_11;
	set mydata.std_rho_11;
	procedure = 2;
run;

data mydata.std_beta1_12;
	set mydata.std_beta1_12;
	procedure = 3;
run;

data mydata.std_rho_12;
	set mydata.std_rho_12;
	procedure = 3;
run;

data mydata.std_beta1_21;
	set mydata.std_beta1_21;
	procedure = 4;
run;

data mydata.std_rho_21;
	set mydata.std_rho_21;
	procedure = 4;
run;

data mydata.std_beta1_22;
	set mydata.std_beta1_22;
	procedure = 5;
run;

data mydata.std_rho_22;
	set mydata.std_rho_22;
	procedure = 5;
run;

data mydata.std_beta1_31;
	set mydata.std_beta1_31;
	procedure = 6;
run;

data mydata.std_rho_31;
	set mydata.std_rho_31;
	procedure = 6;
run;

data mydata.std_beta1_32;
	set mydata.std_beta1_32;
	procedure = 7;
run;

data mydata.std_rho_32;
	set mydata.std_rho_32;
	procedure = 7;
run;

*CP95;

data mydata.cp95_f; /*convert wide format to long format for frequentist results; this is to include both frequentist estimation of corrected and uncorrected rho into glm analysis*/
    set mydata.cp95_f;
    procedure = 1; cp95_rho_comp = cp95_rho_cheang_adj_Mean; output;
    procedure = 8; cp95_rho_comp = cp95_rho_unc_Mean; output;
run;

data mydata.cp95_beta1_11;
	set mydata.cp95_beta1_11;
	procedure = 2;
run;

data mydata.cp95_rho_11;
	set mydata.cp95_rho_11;
	procedure = 2;
run;

data mydata.cp95_beta1_12;
	set mydata.cp95_beta1_12;
	procedure = 3;
run;

data mydata.cp95_rho_12;
	set mydata.cp95_rho_12;
	procedure = 3;
run;

data mydata.cp95_beta1_21;
	set mydata.cp95_beta1_21;
	procedure = 4;
run;

data mydata.cp95_rho_21;
	set mydata.cp95_rho_21;
	procedure = 4;
run;

data mydata.cp95_beta1_22;
	set mydata.cp95_beta1_22;
	procedure = 5;
run;

data mydata.cp95_rho_22;
	set mydata.cp95_rho_22;
	procedure = 5;
run;

data mydata.cp95_beta1_31;
	set mydata.cp95_beta1_31;
	procedure = 6;
run;

data mydata.cp95_rho_31;
	set mydata.cp95_rho_31;
	procedure = 6;
run;

data mydata.cp95_beta1_32;
	set mydata.cp95_beta1_32;
	procedure = 7;
run;

data mydata.cp95_rho_32;
	set mydata.cp95_rho_32;
	procedure = 7;
run;

*type I error;

data mydata.typei_intervention_f;
	set mydata.typei_intervention_f;
	procedure = 1;
run;

data mydata.typei_auto_f;
	set mydata.typei_auto_f;
	procedure = 1;
run;

data mydata.typei_beta1_11;
	set mydata.typei_beta1_11;
	procedure = 2;
run;

data mydata.typei_rho_11;
	set mydata.typei_rho_11;
	procedure = 2;
run;

data mydata.typei_beta1_12;
	set mydata.typei_beta1_12;
	procedure = 3;
run;

data mydata.typei_rho_12;
	set mydata.typei_rho_12;
	procedure = 3;
run;

data mydata.typei_beta1_21;
	set mydata.typei_beta1_21;
	procedure = 4;
run;

data mydata.typei_rho_21;
	set mydata.typei_rho_21;
	procedure = 4;
run;

data mydata.typei_beta1_22;
	set mydata.typei_beta1_22;
	procedure = 5;
run;

data mydata.typei_rho_22;
	set mydata.typei_rho_22;
	procedure = 5;
run;

data mydata.typei_beta1_31;
	set mydata.typei_beta1_31;
	procedure = 6;
run;

data mydata.typei_rho_31;
	set mydata.typei_rho_31;
	procedure = 6;
run;

data mydata.typei_beta1_32;
	set mydata.typei_beta1_32;
	procedure = 7;
run;

data mydata.typei_rho_32;
	set mydata.typei_rho_32;
	procedure = 7;
run;

*power;

data mydata.pow_intervention_f;
	set mydata.pow_intervention_f;
	procedure = 1;
run;

data mydata.pow_auto_f;
	set mydata.pow_auto_f;
	procedure = 1;
run;

data mydata.pow_beta1_11;
	set mydata.pow_beta1_11;
	procedure = 2;
run;

data mydata.pow_rho_11;
	set mydata.pow_rho_11;
	procedure = 2;
run;

data mydata.pow_beta1_12;
	set mydata.pow_beta1_12;
	procedure = 3;
run;

data mydata.pow_rho_12;
	set mydata.pow_rho_12;
	procedure = 3;
run;

data mydata.pow_beta1_21;
	set mydata.pow_beta1_21;
	procedure = 4;
run;

data mydata.pow_rho_21;
	set mydata.pow_rho_21;
	procedure = 4;
run;

data mydata.pow_beta1_22;
	set mydata.pow_beta1_22;
	procedure = 5;
run;

data mydata.pow_rho_22;
	set mydata.pow_rho_22;
	procedure = 5;
run;

data mydata.pow_beta1_31;
	set mydata.pow_beta1_31;
	procedure = 6;
run;

data mydata.pow_rho_31;
	set mydata.pow_rho_31;
	procedure = 6;
run;

data mydata.pow_beta1_32;
	set mydata.pow_beta1_32;
	procedure = 7;
run;

data mydata.pow_rho_32;
	set mydata.pow_rho_32;
	procedure = 7;
run;





