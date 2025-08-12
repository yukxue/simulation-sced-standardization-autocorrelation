%let path = .;  /* The base directory where you'd like to save outputs */
libname analysis "&path.\analysis"; /* NOTE: provide an EMPTY folder before running this macro */

%macro process_datasets;

/* List of dataset suffixes to loop through */
%let datasets = 11 12 21 22 31 32;

/* Loop through each suffix */
%do i = 1 %to %sysfunc(countw(&datasets));
    %let suffix = %scan(&datasets, &i);

/* Define input dataset dynamically */
    %let input_dataset = analysis.bayesian_s1_&suffix;

data analysis.analysis_b_&suffix;
	set &input_dataset;
run;

/*split the dataset*/	

data analysis.analysis_beta1_&suffix;
    set analysis.analysis_b_&suffix;
    if var = 'beta1';
	rename mean = D;
	drop var;
run;

data analysis.analysis_beta1_&suffix;
set analysis.analysis_beta1_&suffix;
rename 
       beta1_mean_s_byresid = DS_byresid_uh
	   beta1_mean_s_byresid_bc = DS_byresid_h
       beta1_mean_s_bywhino = DS_bywn_uh	   
	   beta1_mean_s_bywhino_bc = DS_bywn_h

	   sd = StdErr

       stderr_s_byresid_bc = StdErr_byresid_h
       stderr_s_byresid = StdErr_byresid_uh
       stderr_s_bywhino_bc = StdErr_bywn_h /*corrected standard error, with uncorrected whitenoise (because Cheang is not for Bayesian),with Hedges */
       stderr_s_bywhino = StdErr_bywn_uh; /*corrected standard error, with uncorrected whitenoise (because Cheang is not for Bayesian),no Hedges */

run;


data analysis.analysis_rho_&suffix;
    set analysis.analysis_b_&suffix;
    if var = 'phi';
	rename mean = rho_unc;
	drop beta1_mean_s_bywhino beta1_mean_s_byresid sd_whino sd_resid stderr_s_bywhino stderr_s_byresid stderr_s_bywhino_bc stderr_s_byresid_bc beta1_mean_s_bywhino_bc beta1_mean_s_byresid_bc var;
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;

	bias_D = D - gamma100;
	bias_DS_byresid_uh=DS_byresid_uh - (gamma100/(1/(sqrt(1 - (rho)**2))));
	bias_DS_byresid_h = DS_byresid_h - (gamma100/(1/(sqrt(1 - (rho)**2))));
	bias_DS_bywn_uh = DS_bywn_uh - gamma100;
	bias_DS_bywn_h = DS_bywn_h - gamma100;
	

    MSE_D=(bias_D)**2;
	MSE_DS_byresid_uh=(bias_DS_byresid_uh)**2;
	MSE_DS_byresid_h=(bias_DS_byresid_h)**2;
    MSE_DS_bywn_uh = (bias_DS_bywn_uh)**2;
	MSE_DS_bywn_h = (bias_DS_bywn_h)**2;
	
   
    z95=probit(0.975);
run;

data analysis.analysis_rho_&suffix;
	set analysis.analysis_rho_&suffix;

    rename sd = StdErr; /*sd of autocorrelation in Bayesian results represent standard error of the autocorrelation*/

    bias_rho_unc=rho_unc - rho;
    	
  	MSE_rho_unc=(bias_rho_unc)**2;
      
    z95=probit(0.975);
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;

    L95_D=val2_5pc;
	U95_D=val97_5pc;

	L95_DS_bywn_h=(val2_5pc*(1-3/(4*(T-3)-1)))/sd_whino; 
	U95_DS_bywn_h=(val97_5pc*(1-3/(4*(T-3)-1)))/sd_whino; 

    L95_DS_bywn_uh=val2_5pc/sd_whino; 
	U95_DS_bywn_uh=val97_5pc/sd_whino; 

    L95_DS_byresid_h=(val2_5pc*(1-3/(4*(T-3)-1)))/sd_resid;
    U95_DS_byresid_h=(val97_5pc*(1-3/(4*(T-3)-1)))/sd_resid;

    L95_DS_byresid_uh=val2_5pc/sd_resid;
    U95_DS_byresid_uh=val97_5pc/sd_resid;

run;


data analysis.analysis_rho_&suffix;
	set analysis.analysis_rho_&suffix;

    L95_rho_unc = val2_5pc; 
	U95_rho_unc = val97_5pc; 

run;


data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if gamma100 ne 0 then rel_bias_D = bias_D / gamma100;
		else rel_bias_D = .; 
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if gamma100 ne 0 then rel_bias_DS_byresid_h = bias_DS_byresid_h / (gamma100/(1/(sqrt(1 - (rho)**2))));
		else rel_bias_DS_byresid_h = .; 
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if gamma100 ne 0 then rel_bias_DS_byresid_uh = bias_DS_byresid_uh / (gamma100/(1/(sqrt(1 - (rho)**2))));
		else rel_bias_DS_byresid_uh = .; 
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if gamma100 ne 0 then rel_bias_DS_bywn_h = bias_DS_bywn_h / gamma100;
		else rel_bias_DS_bywn_h = .; 
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
	if gamma100 ne 0 then rel_bias_DS_bywn_uh = bias_DS_bywn_uh / gamma100;
	else rel_bias_DS_bywn_uh = .; 
run;

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.estimate_beta1_&suffix ;
table gamma100 * T * rho ,(Mean Median) * (D DS_byresid_h DS_byresid_uh DS_bywn_h DS_bywn_uh);
var  D DS_byresid_h DS_byresid_uh DS_bywn_h DS_bywn_uh;
class gamma100 T rho;
run;


data analysis.analysis_rho_&suffix;
	set analysis.analysis_rho_&suffix;
		if rho ne 0 then rel_bias_rho_unc = bias_rho_unc / rho;
		else rel_bias_rho_unc = .; 
run;


proc tabulate data=analysis.analysis_rho_&suffix format=best12.2 out=analysis.estimate_rho_&suffix ;
table gamma100 * T * rho ,(Mean Median) * (rho_unc);
var  rho_unc;
class gamma100 T rho;
run;


/*absolute bias*/

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.bias_beta1_&suffix ;
table gamma100 * T * rho ,(Mean Median) * (bias_D bias_DS_byresid_uh bias_DS_byresid_h bias_DS_bywn_uh bias_DS_bywn_h);
var  bias_D bias_DS_byresid_uh bias_DS_byresid_h bias_DS_bywn_uh bias_DS_bywn_h;
class gamma100 T rho;
run;

proc tabulate data=analysis.analysis_rho_&suffix format=best12.2 out=analysis.bias_rho_&suffix ;
table gamma100 * T * rho ,(Mean Median) * (bias_rho_unc);
var  bias_rho_unc;
class gamma100 T rho;
run;

/*relative bias*/

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.relbias_beta1_&suffix;
table gamma100 * T * rho,(Mean Median) * (rel_bias_D rel_bias_DS_byresid_uh rel_bias_DS_byresid_h rel_bias_DS_bywn_uh rel_bias_DS_bywn_h);
var rel_bias_D rel_bias_DS_byresid_uh rel_bias_DS_byresid_h rel_bias_DS_bywn_uh rel_bias_DS_bywn_h;
class gamma100 T rho ;
where gamma100 ne 0;
run;

proc tabulate data=analysis.analysis_rho_&suffix format=best12.2 out=analysis.relbias_rho_&suffix;
table gamma100 * T * rho,(Mean Median) * (rel_bias_rho_unc);
var rel_bias_rho_unc;
class gamma100 T rho ;
where rho ne 0;
run;

/*MSE*/

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.MSE_beta1_&suffix ;
table gamma100 * T * rho,(Mean) * (MSE_D MSE_DS_byresid_uh MSE_DS_byresid_h MSE_DS_bywn_uh MSE_DS_bywn_h);
var  MSE_D MSE_DS_byresid_uh MSE_DS_byresid_h MSE_DS_bywn_uh MSE_DS_bywn_h;
class gamma100  T rho;
run;

proc tabulate data=analysis.analysis_rho_&suffix format=best12.2 out=analysis.MSE_rho_&suffix ;
table gamma100 * T * rho,(Mean) * (MSE_rho_unc);
var  MSE_rho_unc;
class gamma100  T rho;
run;

/* relative standard error*/

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.std_beta1_&suffix;
table gamma100 * T * rho, (Median STD) * (D DS_byresid_uh DS_byresid_h DS_bywn_uh DS_bywn_h StdErr StdErr_byresid_uh StdErr_byresid_h StdErr_bywn_uh StdErr_bywn_h);
var D DS_byresid_uh DS_byresid_h DS_bywn_uh DS_bywn_h StdErr StdErr_byresid_uh StdErr_byresid_h StdErr_bywn_uh StdErr_bywn_h;
class gamma100 T rho;
run;

proc tabulate data=analysis.analysis_rho_&suffix format=best12.2 out=analysis.std_rho_&suffix;
table gamma100 * T * rho, (Median STD) * (rho_unc stderr);
var rho_unc stderr;
class gamma100 T rho;
run;

data analysis.std_beta1_&suffix;
    set analysis.std_beta1_&suffix;
    rel_biasdif_D = (StdErr_Median - D_Std) / D_Std;
run;

data analysis.std_beta1_&suffix;
    set analysis.std_beta1_&suffix;
    rel_biasdif_DS_byresid_uh = (StdErr_byresid_uh_Median - DS_byresid_uh_Std) / DS_byresid_uh_Std;
run;

data analysis.std_beta1_&suffix;
    set analysis.std_beta1_&suffix;
    rel_biasdif_DS_byresid_h = (StdErr_byresid_h_Median - DS_byresid_h_Std) / DS_byresid_h_Std;
run;

data analysis.std_beta1_&suffix;
    set analysis.std_beta1_&suffix;
    rel_biasdif_DS_bywn_uh = (StdErr_bywn_uh_Median - DS_bywn_uh_Std) / DS_bywn_uh_Std;
run;

data analysis.std_beta1_&suffix;
    set analysis.std_beta1_&suffix;
    rel_biasdif_DS_bywn_h = (StdErr_bywn_h_Median - DS_bywn_h_Std) / DS_bywn_h_Std;
run;

data analysis.std_rho_&suffix;
    set analysis.std_rho_&suffix;
    rel_biasdif_rho_unc = (StdErr_Median - rho_unc_Std) / rho_unc_Std;
run;


proc tabulate data=analysis.std_beta1_&suffix format=best12.2   out=analysis.std_beta1_&suffix;
table  gamma100 *  T * rho,(Mean) * (rel_biasdif_D rel_biasdif_DS_byresid_uh rel_biasdif_DS_byresid_h rel_biasdif_DS_bywn_uh rel_biasdif_DS_bywn_h);
var  rel_biasdif_D rel_biasdif_DS_byresid_uh rel_biasdif_DS_byresid_h rel_biasdif_DS_bywn_uh rel_biasdif_DS_bywn_h;
class gamma100 T rho;
run;

proc tabulate data=analysis.std_rho_&suffix format=best12.2   out=analysis.std_rho_&suffix;
table  gamma100 *  T * rho,(Mean) * (rel_biasdif_rho_unc);
var  rel_biasdif_rho_unc;
class gamma100 T rho;
run;

/* CP95 */

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if (L95_D<gamma100<U95_D) then CP95_D=1;
		else CP95_D =0;	
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if (L95_DS_byresid_uh<((gamma100/(1/(sqrt(1 - (rho)**2)))))<U95_DS_byresid_uh) then CP95_DS_byresid_uh=1;
		else CP95_DS_byresid_uh =0;	
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if (L95_DS_byresid_h<((gamma100/(1/(sqrt(1 - (rho)**2)))))<U95_DS_byresid_h) then CP95_DS_byresid_h=1;
		else CP95_DS_byresid_h =0;	
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if (L95_DS_bywn_uh<gamma100<U95_DS_bywn_uh) then CP95_DS_bywn_uh=1;
		else CP95_DS_bywn_uh =0;	
run;

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if (L95_DS_bywn_h<gamma100<U95_DS_bywn_h) then CP95_DS_bywn_h=1;
		else CP95_DS_bywn_h =0;	
run;

data analysis.analysis_rho_&suffix;
	set analysis.analysis_rho_&suffix;
		if (L95_rho_unc<rho<U95_rho_unc) then CP95_rho_unc=1;
		else CP95_rho_unc =0;	
run;

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.3 out=analysis.CP95_beta1_&suffix;
table gamma100 * T * rho,(Mean) * (CP95_D CP95_DS_byresid_uh CP95_DS_byresid_h CP95_DS_bywn_uh CP95_DS_bywn_h);
var CP95_D CP95_DS_byresid_uh CP95_DS_byresid_h CP95_DS_bywn_uh CP95_DS_bywn_h;
class gamma100  T rho;
run;

proc tabulate data=analysis.analysis_rho_&suffix format=best12.3 out=analysis.CP95_rho_&suffix;
table gamma100 * T * rho,(Mean) * (CP95_rho_unc);
var CP95_rho_unc;
class gamma100  T rho;
run;

/* Power*/

/*intervention*/

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;
		if z_value > z95 then pow05_intervention=1;
		else pow05_intervention=0;
run;

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.pow_beta1_&suffix;
table gamma100 * T * rho,(Mean ) * (pow05_intervention);
var pow05_intervention;
class  gamma100  T rho;
where gamma100 ne 0;
run;

/*autocorrelation*/

data analysis.analysis_rho_&suffix;
    set analysis.analysis_rho_&suffix;
    if (z_value > z95 and rho > 0) or (z_value < -z95 and rho < 0) then 
        pow05_autocorrelation = 1;
    else 
        pow05_autocorrelation = 0;
run;

proc tabulate data=analysis.analysis_rho_&suffix format=best12.2 out=analysis.pow_rho_&suffix;
table gamma100 * T * rho,(Mean ) * (pow05_autocorrelation);
var pow05_autocorrelation;
class  gamma100  T rho;
where rho ne 0;
run;

/* Type I Error */

/*intervention*/

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.typeI_beta1_&suffix;
table gamma100 * T * rho,(Mean ) * (pow05_intervention);
var pow05_intervention;
class  gamma100  T rho;
where gamma100 = 0;
run;

/*autocorrelation*/

proc tabulate data=analysis.analysis_rho_&suffix format=best12.2 out=analysis.typeI_rho_&suffix;
table gamma100 * T * rho,(Mean ) * (pow05_autocorrelation);
var pow05_autocorrelation;
class  gamma100  T rho;
where rho = 0;
run;

/*standardization factor*/

data analysis.analysis_beta1_&suffix;
	set analysis.analysis_beta1_&suffix;

	bias_sd_resid = sd_resid - (1/(sqrt(1 - (rho)**2)));
	bias_sd_whino = sd_whino - 1;

	rel_bias_sd_resid = bias_sd_resid / (1/(sqrt(1 - (rho)**2)));
	rel_bias_sd_whino = bias_sd_whino;

    MSE_sd_resid =(bias_sd_resid)**2;
    MSE_sd_whino=(bias_sd_whino) **2;

	run;

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.estimate_sfactor_beta1_&suffix ;
table gamma100 * T * rho,(Mean Median) * (sd_whino sd_resid);
var  sd_whino sd_resid;
class gamma100  T rho;
run;

/*relative bias of estimating the standardization factor*/

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.relbias_sfactor_b_&suffix ;
table gamma100 * T * rho,(Mean Median) * (rel_bias_sd_resid rel_bias_sd_whino);
var rel_bias_sd_resid rel_bias_sd_whino;
class gamma100 T rho ;
run;

/*MSE of estimating the standardization factor*/

proc tabulate data=analysis.analysis_beta1_&suffix format=best12.2 out=analysis.mse_sfactor_b_&suffix ;
table gamma100 * T * rho,(Mean Median) * (MSE_sd_resid MSE_sd_whino);
var MSE_sd_resid MSE_sd_whino;
class gamma100 T rho ;
run;

*ods html close;

%end; /* End of loop */
%mend process_datasets;

/* Execute the macro */
%process_datasets;
