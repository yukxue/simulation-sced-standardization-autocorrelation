%let path = .;  /* The base directory where you'd like to save outputs */
libname analysis "&path.\analysis"; /* NOTE: provide an EMPTY folder before running this macro */

/*Relative bias*/

data relbias_beta1_b;
	set mydata.relbias_beta1_11 mydata.relbias_beta1_12 mydata.relbias_beta1_21 mydata.relbias_beta1_22 mydata.relbias_beta1_31 mydata.relbias_beta1_32;
run;

data relbias_rho_b;
	set mydata.relbias_rho_11 mydata.relbias_rho_12 mydata.relbias_rho_21 mydata.relbias_rho_22 mydata.relbias_rho_31 mydata.relbias_rho_32;
run;

proc sort data=relbias_beta1_b;
    by gamma100 T rho procedure;
run;

proc sort data=relbias_rho_b;
    by gamma100 T rho procedure;
run;

data mydata.relbias_b;
    merge relbias_beta1_b (in=a)
          relbias_rho_b (in=b);
    by gamma100 T rho procedure;
	if a or b;
run;

/* Merge the results of frequentist and Bayesian */
data mydata.relbias_bf;
	retain gamma100 T rho procedure 
           rel_bias_D_Mean rel_bias_DS_byresid_uh_Mean rel_bias_DS_byresid_h_Mean rel_bias_DS_bywn_uh_Mean rel_bias_DS_bywn_h_Mean 
		   rel_bias_DS_bywn_chea_uh_Mean rel_bias_DS_bywn_chea_h_Mean

           rel_bias_D_Median rel_bias_DS_byresid_uh_Median rel_bias_DS_byresid_h_Median rel_bias_DS_bywn_uh_Median rel_bias_DS_bywn_h_Median
		   rel_bias_DS_bywn_chea_uh_Median rel_bias_DS_bywn_chea_h_Median

           rel_bias_rho_unc_Mean
		   rel_bias_rho_comp; /*this variable is mostly created in "6.1 Analysis_bf_S1_within-main"*/

    set mydata.relbias_b mydata.relbias_f;
	if not (gamma100 = 0 and rho = 0);
run;

/*MSE*/

data mse_beta1_b;
	set mydata.mse_beta1_11 mydata.mse_beta1_12 mydata.mse_beta1_21 mydata.mse_beta1_22 mydata.mse_beta1_31 mydata.mse_beta1_32;
run;

data mse_rho_b;
	set mydata.mse_rho_11 mydata.mse_rho_12 mydata.mse_rho_21 mydata.mse_rho_22 mydata.mse_rho_31 mydata.mse_rho_32;
run;

proc sort data=mse_beta1_b;
    by gamma100 T rho procedure;
run;

proc sort data=mse_rho_b;
    by gamma100 T rho procedure;
run;

data mydata.mse_b;
    merge mse_beta1_b (in=a)
          mse_rho_b (in=b);
    by gamma100 T rho procedure;
	if a or b;
run;

/* Merge the results of frequentist and Bayesian */
data mydata.mse_bf;
	retain gamma100 T rho procedure 
           mse_D_Mean mse_DS_byresid_uh_Mean mse_DS_byresid_h_Mean mse_DS_bywn_uh_Mean mse_DS_bywn_h_Mean 
		   mse_DS_bywn_chea_uh_Mean mse_DS_bywn_chea_h_Mean

           mse_D_Median mse_DS_byresid_uh_Median mse_DS_byresid_h_Median mse_DS_bywn_uh_Median mse_DS_bywn_h_Median
		   mse_DS_bywn_chea_uh_Median mse_DS_bywn_chea_h_Median

           mse_rho_unc_Mean
		   mse_rho_comp;

    set mydata.mse_b mydata.mse_f;
run;


/*Relative standard error bias*/

data std_beta1_b;
	set mydata.std_beta1_11 mydata.std_beta1_12 mydata.std_beta1_21 mydata.std_beta1_22 mydata.std_beta1_31 mydata.std_beta1_32;
run;

data std_rho_b;
	set mydata.std_rho_11 mydata.std_rho_12 mydata.std_rho_21 mydata.std_rho_22 mydata.std_rho_31 mydata.std_rho_32;
run;

proc sort data=std_beta1_b;
    by gamma100 T rho procedure;
run;

proc sort data=std_rho_b;
    by gamma100 T rho procedure;
run;

data mydata.std_b;
    merge std_beta1_b (in=a)
          std_rho_b (in=b);
    by gamma100 T rho procedure;
	if a or b;
run;

/* Merge the results of frequentist and Bayesian */
data mydata.std_bf;
	retain gamma100 T rho procedure 
           rel_biasdif_D_Mean rel_biasdif_DS_byresid_uh_Mean rel_biasdif_DS_byresid_h_Mean rel_biasdif_DS_bywn_uh_Mean rel_biasdif_DS_bywn_h_Mean 
		   rel_biasdif_DS_bywn_chea_uh_Mean rel_biasdif_DS_bywn_chea_h_Mean

           rel_biasdif_rho_unc_Mean
		   rel_biasdif_rho_comp;

    set mydata.std_b mydata.std_f;
run;


/*CP95*/

data cp95_beta1_b;
	set mydata.cp95_beta1_11 mydata.cp95_beta1_12 mydata.cp95_beta1_21 mydata.cp95_beta1_22 mydata.cp95_beta1_31 mydata.cp95_beta1_32;
run;

data cp95_rho_b;
	set mydata.cp95_rho_11 mydata.cp95_rho_12 mydata.cp95_rho_21 mydata.cp95_rho_22 mydata.cp95_rho_31 mydata.cp95_rho_32;
run;

proc sort data=cp95_beta1_b;
    by gamma100 T rho procedure;
run;

proc sort data=cp95_rho_b;
    by gamma100 T rho procedure;
run;

data mydata.cp95_b;
    merge cp95_beta1_b (in=a)
          cp95_rho_b (in=b);
    by gamma100 T rho procedure;
	if a or b;
run;

/* Merge the results of frequentist and Bayesian */
data mydata.cp95_bf;
	retain gamma100 T rho procedure 
           cp95_D_Mean cp95_DS_byresid_uh_Mean cp95_DS_byresid_h_Mean cp95_DS_bywn_uh_Mean cp95_DS_bywn_h_Mean 
		   cp95_DS_bywn_chea_uh_Mean cp95_DS_bywn_chea_h_Mean

           cp95_D_Median cp95_DS_byresid_uh_Median cp95_DS_byresid_h_Median cp95_DS_bywn_uh_Median cp95_DS_bywn_h_Median
		   cp95_DS_bywn_chea_uh_Median cp95_DS_bywn_chea_h_Median

           cp95_rho_unc_Mean
		   cp95_rho_comp;

    set mydata.cp95_b mydata.cp95_f;
run;


/*power*/

data pow_beta1_b;
	set mydata.pow_beta1_11 mydata.pow_beta1_12 mydata.pow_beta1_21 mydata.pow_beta1_22 mydata.pow_beta1_31 mydata.pow_beta1_32;
run;

data pow_rho_b;
	set mydata.pow_rho_11 mydata.pow_rho_12 mydata.pow_rho_21 mydata.pow_rho_22 mydata.pow_rho_31 mydata.pow_rho_32;
run;

proc sort data=pow_beta1_b;
    by gamma100 T rho procedure;
run;

proc sort data=pow_rho_b;
    by gamma100 T rho procedure;
run;

data mydata.pow_b;
    merge pow_beta1_b (in=a)
          pow_rho_b (in=b);
    by gamma100 T rho procedure;
	if a or b;
run;

proc sort data=mydata.pow_intervention_f;
    by gamma100 T rho procedure;
run;

proc sort data=mydata.pow_auto_f;
    by gamma100 T rho procedure;
run;

data mydata.pow_f;
     merge mydata.pow_intervention_f  (in=a)
	       mydata.pow_auto_f  (in=b);
	 by gamma100 T rho procedure;
	 if a or b;
run;


/* Merge the results of frequentist and Bayesian */
data mydata.pow_bf;
	retain gamma100 T rho procedure 
           pow05_D_Mean pow05_DS_byresid_uh_Mean pow05_DS_byresid_h_Mean pow05_DS_bywn_uh_Mean pow05_DS_bywn_h_Mean 
		   pow05_DS_bywn_chea_uh_Mean pow05_DS_bywn_chea_h_Mean

           pow05_D_Median pow05_DS_byresid_uh_Median pow05_DS_byresid_h_Median pow05_DS_bywn_uh_Median pow05_DS_bywn_h_Median
		   pow05_DS_bywn_chea_uh_Median pow05_DS_bywn_chea_h_Median

           pow05_rho_unc_Mean
		   pow05_rho_chea_adj_Mean

           pow05_rho_unc_Median
           pow05_rho_chea_adj_Median;

    set mydata.pow_b mydata.pow_f;
run;


/*type I error rate*/

data typei_beta1_b;
	set mydata.typei_beta1_11 mydata.typei_beta1_12 mydata.typei_beta1_21 mydata.typei_beta1_22 mydata.typei_beta1_31 mydata.typei_beta1_32;
run;

data typei_rho_b;
	set mydata.typei_rho_11 mydata.typei_rho_12 mydata.typei_rho_21 mydata.typei_rho_22 mydata.typei_rho_31 mydata.typei_rho_32;
run;

proc sort data=typei_beta1_b;
    by gamma100 T rho procedure;
run;

proc sort data=typei_rho_b;
    by gamma100 T rho procedure;
run;

data mydata.typei_b;
    merge typei_beta1_b (in=a)
          typei_rho_b (in=b);
    by gamma100 T rho procedure;
	if a or b;
run;

proc sort data=mydata.typei_intervention_f;
    by gamma100 T rho procedure;
run;

proc sort data=mydata.typei_auto_f;
    by gamma100 T rho procedure;
run;

data mydata.typei_f;
     merge mydata.typei_intervention_f  (in=a)
	       mydata.typei_auto_f  (in=b);
	 by gamma100 T rho procedure;
	 if a or b;
run;


/* Merge the results of frequentist and Bayesian */
data mydata.typei_bf;
	retain gamma100 T rho procedure 
           pow05_D_Mean pow05_DS_byresid_uh_Mean pow05_DS_byresid_h_Mean pow05_DS_bywn_uh_Mean pow05_DS_bywn_h_Mean 
		   pow05_DS_bywn_chea_uh_Mean pow05_DS_bywn_chea_h_Mean

           pow05_D_Median pow05_DS_byresid_uh_Median pow05_DS_byresid_h_Median pow05_DS_bywn_uh_Median pow05_DS_bywn_h_Median
		   pow05_DS_bywn_chea_uh_Median pow05_DS_bywn_chea_h_Median

           pow05_rho_unc_Mean
		   pow05_rho_chea_adj_Mean

           pow05_rho_unc_Median
           pow05_rho_chea_adj_Median;

    set mydata.typei_b mydata.typei_f;
run;


/*Standardization factor*/

/*relative bias*/

data mydata.relbias_sfactor_b;
	set mydata.relbias_sfactor_b_11 mydata.relbias_sfactor_b_12 mydata.relbias_sfactor_b_21 mydata.relbias_sfactor_b_22 mydata.relbias_sfactor_b_31 mydata.relbias_sfactor_b_32;
run;

/* Merge the results of frequentist and Bayesian */
data mydata.relbias_sfactor_bf;
	retain gamma100 T rho procedure sfactor_mean sfactor_median;
    set mydata.relbias_sfactor_b mydata.relbias_sfactor_f;
run;

/*MSE*/

data mydata.mse_sfactor_b;
	set mydata.mse_sfactor_b_11 mydata.mse_sfactor_b_12 mydata.mse_sfactor_b_21 mydata.mse_sfactor_b_22 mydata.mse_sfactor_b_31 mydata.mse_sfactor_b_32;
run;

/* Merge the results of frequentist and Bayesian */
data mydata.mse_sfactor_bf;
	retain gamma100 T rho procedure sfactor_mean sfactor_median;
    set mydata.mse_sfactor_b mydata.mse_sfactor_f;
run;




