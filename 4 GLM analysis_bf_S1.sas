%let path = .;  /* The base directory where you'd like to save outputs */
libname analysis "&path.\analysis"; /* NOTE: provide an EMPTY folder before running this macro */

/* Relative bias */

/*create a new variable for Intervention effects,
where frequentist anaysis uses cheang, Hedges's correction, and whitenoise
where Bayesian analysis uses Hedges's correction and whitenoise*/

data analysis.relbias_bf_compare;
    set analysis.relbias_bf;
    if procedure = 1 then rel_bias_DS_comp = rel_bias_DS_bywn_chea_h_Mean;
    else if procedure in (2, 3, 4, 5, 6, 7) then rel_bias_DS_comp = rel_bias_DS_bywn_h_Mean;
run;

data analysis.relbias_bf_compare;
    set analysis.relbias_bf_compare;
    if procedure in (2, 3, 4, 5, 6, 7) then rel_bias_rho_comp = rel_bias_rho_unc_Mean;
run;

proc glm data=analysis.relbias_bf_compare;
    where procedure in (1, 2, 3, 4, 5, 6, 7);
    class T rho procedure;
    model rel_bias_DS_comp = procedure T rho procedure*T procedure*rho T*rho  / ss3 effectsize;
run;


proc glm data=analysis.relbias_bf_compare;
class gamma100 T rho procedure ;
Model rel_bias_rho_comp = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho  /ss3 effectsize;
run;


/* MSE */

data analysis.mse_bf_compare;
    set analysis.mse_bf;
    if procedure = 1 then mse_DS_comp = mse_DS_bywn_chea_h_Mean;
    else if procedure in (2, 3, 4, 5, 6, 7) then mse_DS_comp = mse_DS_bywn_h_Mean;
run;

data analysis.mse_bf_compare;
    set analysis.mse_bf_compare;
    if procedure in (2, 3, 4, 5, 6, 7) then mse_rho_comp = mse_rho_unc_Mean;
run;

proc glm data=analysis.mse_bf_compare;
    where procedure in (1, 2, 3, 4, 5, 6, 7);
    class gamma100 T rho procedure;
    model mse_DS_comp = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

proc glm data=analysis.mse_bf_compare;
    class gamma100 T rho procedure;
    model mse_rho_comp = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/* Relative standard error */

data analysis.std_bf_compare;
    set analysis.std_bf;
    if procedure = 1 then rel_biasdif_DS_comp = rel_biasdif_DS_bywn_chea_h_Mean;
    else if procedure in (2, 3, 4, 5, 6, 7) then rel_biasdif_DS_comp = rel_biasdif_DS_bywn_h_Mean;
run;

data analysis.std_bf_compare;
    set analysis.std_bf_compare;
    if procedure in (2, 3, 4, 5, 6, 7) then rel_biasdif_rho_comp = rel_biasdif_rho_unc_Mean;
run;

proc glm data=analysis.std_bf_compare;
    where procedure in (1, 2, 3, 4, 5, 6, 7);
    class gamma100 T rho procedure;
    model rel_biasdif_DS_comp = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

proc glm data=analysis.std_bf_compare;
    class gamma100 T rho procedure;
    model rel_biasdif_rho_comp = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/*CP95*/

data analysis.cp95_bf_compare;
    set analysis.cp95_bf;
    if procedure = 1 then cp95_DS_comp = cp95_DS_bywn_chea_h_Mean;
    else if procedure in (2, 3, 4, 5, 6, 7) then cp95_DS_comp = cp95_DS_bywn_h_Mean;
run;

data analysis.cp95_bf_compare;
    set analysis.cp95_bf_compare;
    if procedure in (2, 3, 4, 5, 6, 7) then cp95_rho_comp = cp95_rho_unc_Mean;
run;

proc glm data=analysis.cp95_bf_compare;
    where procedure in (1, 2, 3, 4, 5, 6, 7);
    class gamma100 T rho procedure;
    model cp95_DS_comp = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

proc glm data=analysis.cp95_bf_compare;
    class gamma100 T rho procedure;
    model cp95_rho_comp = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/*power*/

proc glm data=analysis.pow_bf;
    class T rho procedure;
    model pow05_intervention_mean = procedure T rho procedure*T procedure*rho T*rho / ss3 effectsize;
run;

proc glm data=analysis.pow_bf;
    class T rho procedure;
    model pow05_autocorrelation_mean = procedure T rho procedure*T procedure*rho T*rho / ss3 effectsize;
run;

/*Type I error*/

proc glm data=analysis.typei_bf;
    class T rho procedure;
    model pow05_intervention_mean = procedure T rho procedure*T procedure*rho T*rho / ss3 effectsize;
run;

/*note that there are no variances for the values of pow05_autocorrelation_mean*/
proc glm data=analysis.typei_bf;
    class T rho procedure;
    model pow05_autocorrelation_mean = procedure T rho procedure*T procedure*rho T*rho / ss3 effectsize;
run;


/*Mean_Standardization factor*/

* relative bias;

/*Full comparison: (1) frequentist residual sd, (2) frequentist white noise sd, (3) frequentist corrected white noise sd, (4) Bayesian residual sd, (5) Bayesian white noise sd*/

proc glm data=analysis.relbias_sfactor_bf;
    class T rho procedure;
    model sfactor_mean = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/*Partial comparison: (4) Bayesian residual sd*/

/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.relbias_sfactor_bf;
    where procedure in (6, 8, 10, 12, 14, 16);
    class T rho procedure;
    model sfactor_mean = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/*Partial comparison: (5) Bayesian white noise sd*/
/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.relbias_sfactor_bf;
    where procedure in (5, 7, 9, 11, 13, 15);
    class T rho procedure;
    model sfactor_mean = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize; 
run;

* MSE;

/*Full comparison: (1) frequentist residual sd, (2) frequentist white noise sd, (3) frequentist corrected white noise sd, (4) Bayesian residual sd, (5) Bayesian white noise sd*/

proc glm data=analysis.mse_sfactor_bf;
    class T rho procedure;
    model sfactor_mean = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;


/*Partial comparison: (4) Bayesian residual sd*/
/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.mse_sfactor_bf;
    where procedure in (6, 8, 10, 12, 14, 16);
    class T rho procedure;
    model sfactor_mean = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;


/*Partial comparison: (5) Bayesian white noise sd*/
/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.mse_sfactor_bf;
    where procedure in (5, 7, 9, 11, 13, 15);
    class T rho procedure;
    model sfactor_mean = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;


/*Median_Standardization factor*/

* relative bias;

/*Full comparison: (1) frequentist residual sd, (2) frequentist white noise sd, (3) frequentist corrected white noise sd, (4) Bayesian residual sd, (5) Bayesian white noise sd*/

proc glm data=analysis.relbias_sfactor_bf;
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/*Partial comparison: (4) Bayesian residual sd*/
/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.relbias_sfactor_bf;
    where procedure in (6, 8, 10, 12, 14, 16);
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/*Partial comparison: (5) Bayesian white noise sd*/
/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.relbias_sfactor_bf;
    where procedure in (5, 7, 9, 11, 13, 15);
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;


/*Slected comparison: (1) frequentist residual sd, (2) frequentist white noise sd, (3) frequentist corrected white noise sd, (4) Bayesian residual sd_11, (5) Bayesian white noise sd_11*/

proc glm data=analysis.relbias_sfactor_bf;
    where procedure in (1, 2, 3, 4, 5, 6);
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

* MSE;

/*Full comparison: (1) frequentist residual sd, (2) frequentist white noise sd, (3) frequentist corrected white noise sd, (4) Bayesian residual sd, (5) Bayesian white noise sd*/

proc glm data=analysis.mse_sfactor_bf;
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;


/*Partial comparison: (4) Bayesian residual sd*/
/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.mse_sfactor_bf;
    where procedure in (6, 8, 10, 12, 14, 16);
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;


/*Partial comparison: (5) Bayesian white noise sd*/
/*the purpose is to check whether the estimates differ a lot across different priors; if not, no need to present the Bayesian results with all the different priors*/

proc glm data=analysis.mse_sfactor_bf;
    where procedure in (5, 7, 9, 11, 13, 15);
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

/*Slected comparison: (1) frequentist residual sd, (2) frequentist white noise sd, (3) frequentist corrected white noise sd, (4) Bayesian residual sd_11, (5) Bayesian white noise sd_11*/

proc glm data=analysis.mse_sfactor_bf;
    where procedure in (1, 2, 3, 4, 5, 6);
    class T rho procedure;
    model sfactor_median = procedure T gamma100 rho procedure*T procedure*gamma100 procedure*rho T*gamma100 T*rho gamma100*rho / ss3 effectsize;
run;

*ods html close;


