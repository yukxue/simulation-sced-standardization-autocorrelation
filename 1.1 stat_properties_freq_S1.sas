%let path = .;  /* The base directory where you'd like to save outputs */
libname analysis "&path.\analysis"; /* NOTE: provide an EMPTY folder before running this macro */


data analysis.analysis_f;
	set analysis.frequentist_s1;
run;

data analysis.analysis_f;
    set analysis.analysis_f;
    rename 

    estimateS_byresid = DS_byresid_uh       /*standardized by residual sd, no Hedges*/
    estimateS_byresidl_bc = DS_byresid_h    /*standardized by residual sd, with Hedges*/
    StdErr_byresid_bc = StdErr_byresid_h

    estimateS_bywhino_unc = DS_bywn_uh   /*standardized by white noise sd, no Hedges*/
    estimateS_bywhino_unc_bc = DS_bywn_h     /*standardized by white noise sd, with Hedges*/
    StdErr_bywhino_unc_bc = StdErr_bywn_h /*corrected standard error, with uncorrected white noise, with Hedges*/

    estimateS_bywhino_cheang = DS_bywn_chea_uh  /* corrected white noise, no Hedges*/
    estimateS_bywhino_cheang_bc = DS_bywn_chea_h /* corrected white noise, with Hedges*/
    StdErr_bywhino_cheang_bc = StdErr_bywn_chea_h; /* corrected standard error, with corrected white noise, with Hedges*/          

run;

/*adding corrected residual sd (by Cheang) and the corresponding standardized effect*/
data analysis.analysis_f;
    set analysis.analysis_f;

	rename 
	RMSE = RMSE_unc;

	RMSE_chea = sd_whino_cheang /(sqrt(1 - (rho_cheang_adj)**2));

	DS_byresid_chea_unh = D / RMSE_chea;
	DS_byresid_chea_h = (D / RMSE_chea)*(1-3/(4*(T-3)-1));

run;


/*prepare for analysis of intervention effect and autocorrelation*/	
data analysis.analysis_f;
	set analysis.analysis_f;

	/* Filter rows where D and stdErr are not missing and MS is not equal to 0 */
    if not missing(D) and not missing(stdErr) and MS ne 0 then output;

run;
	
data analysis.analysis_f;
	set analysis.analysis_f;

	bias_D = D - gamma100;

	bias_DS_byresid_uh=DS_byresid_uh - (gamma100/(1/(sqrt(1 - (rho)**2))));
	bias_DS_byresid_h = DS_byresid_h   - (gamma100/(1/(sqrt(1 - (rho)**2))));
	bias_DS_byresid_chea_uh = DS_byresid_chea_uh -(gamma100/(1/(sqrt(1 - (rho)**2))));
	bias_DS_byresid_chea_h = DS_byresid_chea_h -(gamma100/(1/(sqrt(1 - (rho)**2))));

	bias_DS_bywn_uh = DS_bywn_uh - gamma100;
	bias_DS_bywn_h = DS_bywn_h - gamma100;
	bias_DS_bywn_chea_uh = DS_bywn_chea_uh - gamma100;
	bias_DS_bywn_chea_h = DS_bywn_chea_h - gamma100;

    bias_rho_unc=rho_unc - rho;
    bias_rho_chea_adj = rho_cheang_adj -  rho;
	
    MSE_D=(bias_D)**2;

	MSE_DS_byresid_uh=(bias_DS_byresid_uh)**2;
	MSE_DS_byresid_h=(bias_DS_byresid_h)**2;
	MSE_DS_byresid_chea_uh = (bias_DS_byresid_chea_uh) **2;
	MSE_DS_byresid_chea_h =  (bias_DS_byresid_chea_h) **2;

	MSE_DS_bywn_uh = (bias_DS_bywn_uh)**2;
	MSE_DS_bywn_h = (bias_DS_bywn_h)**2;
	MSE_DS_bywn_chea_uh = (bias_DS_bywn_chea_uh)**2;
	MSE_DS_bywn_chea_h = (bias_DS_bywn_chea_h)**2;

	MSE_rho_unc=(bias_rho_unc)**2;
    MSE_rho_chea_adj=(bias_rho_chea_adj)**2;
  
    t95=Tinv(.975,df); 
	z95=probit(0.975);
run;


data analysis.analysis_f;
	set analysis.analysis_f;

    L95_D=D-t95*stderr; 
	U95_D=D+t95*stderr;

	L95_DS_bywn_chea_h=DS_bywn_chea_h-t95*stderr_bywn_chea_h; 
	U95_DS_bywn_chea_h=DS_bywn_chea_h+t95*stderr_bywn_chea_h;

	L95_rho_unc = rho_unc - z95*rho_se;
	U95_rho_unc = rho_unc + z95*rho_se;

    L95_rho_cheang_adj = rho_cheang_adj - z95*rho_se_cheang;
	U95_rho_cheang_adj = rho_cheang_adj + z95*rho_se_cheang;

run;


data analysis.analysis_f;
	set analysis.analysis_f;
 	if gamma100 ne 0 then rel_bias_D = bias_D / gamma100;
	else rel_bias_D = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
 	if gamma100 ne 0 then rel_bias_DS_byresid_h = bias_DS_byresid_h / (gamma100/(1/(sqrt(1 - (rho)**2))));
	else rel_bias_DS_byresid_h = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if gamma100 ne 0 then rel_bias_DS_byresid_uh = bias_DS_byresid_uh / (gamma100/(1/(sqrt(1 - (rho)**2))));
	else rel_bias_DS_byresid_uh = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if gamma100 ne 0 then rel_bias_DS_bywn_uh = bias_DS_bywn_uh / gamma100;
	else rel_bias_DS_bywn_uh = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if gamma100 ne 0 then rel_bias_DS_bywn_h = bias_DS_bywn_h / gamma100;
	else rel_bias_DS_bywn_h = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if gamma100 ne 0 then rel_bias_DS_bywn_chea_uh = bias_DS_bywn_chea_uh / gamma100;
	else rel_bias_DS_bywn_chea_uh = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if gamma100 ne 0 then rel_bias_DS_bywn_chea_h = bias_DS_bywn_chea_h / gamma100;
	else rel_bias_DS_bywn_chea_h = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if rho ne 0 then rel_bias_rho_unc = bias_rho_unc / rho;
	else rel_bias_rho_unc = .; 
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if rho ne 0 then rel_bias_rho_chea_adj = bias_rho_chea_adj / rho;
	else rel_bias_rho_chea_adj = .; 
run;


proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.estimate_f;
table gamma100 * T * rho ,(Mean Median) * (D DS_byresid_uh  DS_byresid_h DS_bywn_uh DS_bywn_h DS_bywn_chea_uh DS_bywn_chea_h rho_unc rho_cheang_adj);
var  D DS_byresid_uh  DS_byresid_h DS_bywn_uh DS_bywn_h DS_bywn_chea_uh DS_bywn_chea_h rho_unc rho_cheang_adj;
class gamma100 T rho;
run;


/*absolute bias*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.bias_f ;
table gamma100 * T * rho ,(Mean Median) * (bias_D bias_DS_byresid_uh bias_DS_bywn_uh bias_DS_bywn_chea_uh bias_DS_byresid_h bias_DS_bywn_h bias_DS_bywn_chea_h bias_rho_unc bias_rho_chea_adj);
var  bias_D bias_DS_byresid_uh bias_DS_bywn_uh bias_DS_bywn_chea_uh bias_DS_byresid_h bias_DS_bywn_h bias_DS_bywn_chea_h bias_rho_unc bias_rho_chea_adj;
class gamma100 T rho;
run;

/*relative bias*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.relbias_f ;
table gamma100 * T * rho,(Mean Median) * (rel_bias_D rel_bias_DS_byresid_uh rel_bias_DS_bywn_uh rel_bias_DS_bywn_chea_uh rel_bias_DS_byresid_h rel_bias_DS_bywn_h rel_bias_DS_bywn_chea_h rel_bias_rho_unc rel_bias_rho_chea_adj);
var rel_bias_D rel_bias_DS_byresid_uh rel_bias_DS_bywn_uh rel_bias_DS_bywn_chea_uh rel_bias_DS_byresid_h rel_bias_DS_bywn_h rel_bias_DS_bywn_chea_h rel_bias_rho_unc rel_bias_rho_chea_adj;
class gamma100 T rho ;
run;


/*MSE*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.MSE_f ;
table gamma100 * T * rho,(Mean) * (MSE_D MSE_DS_byresid_uh MSE_DS_bywn_uh MSE_DS_bywn_chea_uh MSE_DS_byresid_h MSE_DS_bywn_h MSE_DS_bywn_chea_h MSE_rho_unc MSE_rho_chea_adj);
var  MSE_D MSE_DS_byresid_uh MSE_DS_bywn_uh MSE_DS_bywn_chea_uh MSE_DS_byresid_h MSE_DS_bywn_h MSE_DS_bywn_chea_h MSE_rho_unc MSE_rho_chea_adj;
class gamma100  T rho;
run;

/* relative standard error*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.std_f;
table gamma100 * T * rho, (Median STD) * (D DS_byresid_h DS_bywn_h DS_bywn_chea_h rho_unc rho_cheang_adj stderr StdErr_byresid_h StdErr_bywn_h stderr_bywn_chea_h rho_se rho_se_cheang);
var D DS_byresid_h DS_bywn_h DS_bywn_chea_h rho_unc rho_cheang_adj stderr StdErr_byresid_h StdErr_bywn_h stderr_bywn_chea_h rho_se rho_se_cheang;
class gamma100 T rho;
run;

data analysis.std_f;
    set analysis.std_f;
    rel_biasdif_D = (StdErr_Median - D_Std) / D_Std;
run;

data analysis.std_f;
    set analysis.std_f;
    rel_biasdif_DS_byresid_h = (StdErr_byresid_h_Median - DS_byresid_h_Std) / DS_byresid_h_Std;
run;

data analysis.std_f;
    set analysis.std_f;
    rel_biasdif_DS_bywn_h = (stderr_bywn_h_Median - DS_bywn_h_Std) / DS_bywn_h_Std;
run;

data analysis.std_f;
    set analysis.std_f;
    rel_biasdif_DS_bywn_chea_h = (stderr_bywn_chea_h_Median - DS_bywn_chea_h_Std) / DS_bywn_chea_h_Std;
run;

data analysis.std_f;
    set analysis.std_f;
    rel_biasdif_rho_unc = (rho_se_Median - rho_unc_Std) / rho_unc_Std;
run;

data analysis.std_f;
    set analysis.std_f;
    rel_biasdif_rho_chea_adj = (rho_se_cheang_Median - rho_cheang_adj_Std) / rho_cheang_adj_Std;
run;

proc tabulate data=analysis.std_f format=best12.2   out=analysis.std_f;
table  gamma100 *  T * rho,(Mean) * (rel_biasdif_D rel_biasdif_DS_byresid_h rel_biasdif_DS_bywn_h rel_biasdif_DS_bywn_chea_h rel_biasdif_rho_unc rel_biasdif_rho_chea_adj);
var  rel_biasdif_D rel_biasdif_DS_byresid_h rel_biasdif_DS_bywn_h rel_biasdif_DS_bywn_chea_h rel_biasdif_rho_unc rel_biasdif_rho_chea_adj;
class gamma100 T rho;
run;

/* CP95 */
data analysis.analysis_f;
	set analysis.analysis_f;
	if (L95_D<gamma100<U95_D) then CP95_D=1;
	else CP95_D =0;	
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if (L95_DS_bywn_chea_h<gamma100<U95_DS_bywn_chea_h) then CP95_DS_bywn_chea_h=1;
	else CP95_DS_bywn_chea_h =0;	
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if (L95_rho_unc<rho<U95_rho_unc) then CP95_rho_unc=1;
	else CP95_rho_unc =0;	
run;

data analysis.analysis_f;
	set analysis.analysis_f;
	if (L95_rho_cheang_adj<rho<U95_rho_cheang_adj) then CP95_rho_cheang_adj=1;
	else CP95_rho_cheang_adj =0;	
run;


proc tabulate data=analysis.analysis_f format=best12.3 out=analysis.CP95_f;
table gamma100 * T * rho,(Mean) * (CP95_D CP95_DS_bywn_chea_h CP95_rho_unc CP95_rho_cheang_adj);
var CP95_D CP95_DS_bywn_chea_h CP95_rho_unc CP95_rho_cheang_adj;
class gamma100  T rho;
run;

/* Power*/

/*intervention*/

data analysis.analysis_f;
set analysis.analysis_f;
if tValue > t95 then pow05_intervention=1;
else pow05_intervention=0;
run;

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.pow_intervention_f;
table gamma100 * T * rho,(Mean ) * (pow05_intervention);
var pow05_intervention;
class  gamma100  T rho;
where gamma100 ne 0;
run;

/*autocorrelation*/

data analysis.analysis_f;
	set analysis.analysis_f;
		if (rho_z_value > z95 and rho > 0) or (rho_z_value < -z95 and rho < 0) then 
		    pow05_autocorrelation = 1;
		else 
		    pow05_autocorrelation = 0;
run;

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.pow_auto_f;
table gamma100 * T * rho,(Mean ) * (pow05_autocorrelation);
var pow05_autocorrelation;
class  gamma100  T rho;
where rho ne 0;
run;

	/* Type I Error */

/*intervention*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.typeI_intervention_f;
table gamma100 * T * rho,(Mean ) * (pow05_intervention);
var pow05_intervention;
class  gamma100  T rho;
where gamma100 = 0;
run;

/*autocorrelation*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.typeI_auto_f;
table gamma100 * T * rho,(Mean ) * (pow05_autocorrelation);
var pow05_autocorrelation;
class  gamma100  T rho;
where rho = 0;
run;

/*standardization factor*/

data analysis.analysis_f;
	set analysis.analysis_f;

	bias_RMSE_unc = RMSE_unc - (1/(sqrt(1 - (rho)**2)));
	bias_RMSE_chea = RMSE_chea - (1/(sqrt(1 - (rho)**2)));

	bias_sd_whino_unc = sd_whino_unc - 1;
	bias_sd_whino_chea = sd_whino_cheang - 1;

	rel_bias_RMSE_unc = bias_RMSE_unc / (1/(sqrt(1 - (rho)**2)));
	rel_bias_RMSE_chea = bias_RMSE_chea / (1/(sqrt(1 - (rho)**2)));

	rel_bias_sd_whino_unc = bias_sd_whino_unc;
	rel_bias_sd_whino_chea = bias_sd_whino_chea ;

    MSE_RMSE_unc =(bias_RMSE_unc)**2;
	MSE_RMSE_chea =(bias_RMSE_chea)**2;

	MSE_sd_whino_unc=(bias_sd_whino_unc) **2;
	MSE_sd_whino_chea = (rel_bias_sd_whino_chea)**2; 

	run;

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.estimate_sfactor_f ;
table gamma100 * T * rho,(Mean Median) * (RMSE_unc RMSE_chea sd_whino_unc sd_whino_cheang);
var  RMSE_unc RMSE_chea sd_whino_unc sd_whino_cheang;
class gamma100  T rho;
run;

/*relative bias of estimating the standardization factor*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.relbias_sfactor_f ;
table gamma100 * T * rho,(Mean Median) * (rel_bias_RMSE_unc rel_bias_RMSE_chea rel_bias_sd_whino_unc rel_bias_sd_whino_chea);
var rel_bias_RMSE_unc rel_bias_RMSE_chea rel_bias_sd_whino_unc rel_bias_sd_whino_chea;
class gamma100 T rho ;
run;

/*MSE of estimating the standardization factor*/

proc tabulate data=analysis.analysis_f format=best12.2 out=analysis.mse_sfactor_f ;
table gamma100 * T * rho,(Mean Median) * (MSE_RMSE_unc MSE_RMSE_chea MSE_sd_whino_unc MSE_sd_whino_chea);
var MSE_RMSE_unc MSE_RMSE_chea MSE_sd_whino_unc MSE_sd_whino_chea;
class gamma100 T rho ;
run;

*ods html close;

