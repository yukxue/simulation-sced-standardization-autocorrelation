%let path = .;  /* The base directory where you'd like to save outputs */
libname results "&path.\output"; /* NOTE: provide an EMPTY folder before running this macro */

ods graphics off;
ods listing close;  		* avoid output information;
ods results off;			* avoid results information ;
options nonotes;			* avoid logging information;

%macro aera;

%do a=1 %to 1000 /* number of simulated datasets for each condition */

%let gamma000=0; /* mean baseline level = 0 */

/* mean level effect */
%do b= 1 %to 2; 
	%if &b=1 %then %let gamma100=0;
	%if &b=2 %then %let gamma100=2;

/* number of measurement occasions */
%do c=1 %to 4; 
	%if &c=1 %then %let t=10;
	%if &c=2 %then %let t=20;
	%if &c=3 %then %let t=30;
	%if &c=4 %then %let t=40;

/* autocorrelation coefficients */
%do d=1 %to 19; 
	%if &d=1 %then %let rho = -0.9;
	%if &d=2 %then %let rho = -0.8;
	%if &d=3 %then %let rho = -0.7;
	%if &d=4 %then %let rho = -0.6;
	%if &d=5 %then %let rho = -0.5;
	%if &d=6 %then %let rho = -0.4;
	%if &d=7 %then %let rho = -0.3;
	%if &d=8 %then %let rho = -0.2;
	%if &d=9 %then %let rho = -0.1;
	%if &d=10 %then %let rho = 0.0;
	%if &d=11 %then %let rho = 0.1;
	%if &d=12 %then %let rho = 0.2;
	%if &d=13 %then %let rho = 0.3;
	%if &d=14 %then %let rho = 0.4;
	%if &d=15 %then %let rho = 0.5;
	%if &d=16 %then %let rho = 0.6;
	%if &d=17 %then %let rho = 0.7;
	%if &d=18 %then %let rho = 0.8;
	%if &d=19 %then %let rho = 0.9;

/* AR(1) process */
data raw;
	case = 1;
	e_previous = 0; /* Initialize previous error term for the first observation */

	do moment = 1 to &t;
		epsilon = rannor(0)* sqrt(1); /* white noise*/
		e = &rho * e_previous +  epsilon; 
		e_previous = e;
		output;
	end;

run;


/*generalize raw data */
data raw;
    set raw;

    D  = 0;
    na = (&t / 2) + 1;

    /* Set D = 1 for observations at or after the cutoff point */
    if moment >= na then D = 1;

    /* Calculate observed "y" values */
    y = (&gamma000) + (&gamma100) * D + e;

run;

 
/****************************************
* Bayesian estimation: Stage 1 (11) 
****************************************/

%let filepath = /network/rit/lab/moeyaertlab/yx/dec2024/yx/logS1.txt;
/*%let filepath = Z:/yx/bayeresultYX_S1_noJ/logS1.txt;*/

/* Goal: Delete the log file if it exists */

%macro delete_file(filepath);
    %local rc fileref rc_delete;
    %let fileref = delref;

/* Assign the fileref to the file path */
%let rc = %sysfunc(filename(fileref, &filepath));

%if %sysfunc(fexist(&fileref)) %then %do;
	%let rc_delete = %sysfunc(fdelete(&fileref));
	%if &rc_delete = 0 %then 
		%put File deleted successfully.;
    %else 
		%put File deletion failed. RC=&rc_delete;
%end;

%else 
	%put File does not exist, no need to delete.;

/* Clear the fileref */
%let rc = %sysfunc(filename(fileref));
%mend delete_file;

/* run the macro */
%delete_file(&filepath);

/* run the code for Bayesian estimation */

%include '/network/rit/lab/moeyaertlab/yx/dec2024/yx/ob_s1_11.sas';

data OBoutput;
	set temp_Bayes_S1; 
run;

/* standardization */

/* Step 1: Create a dataset with mean values for tau */

data tau_means;
	set Oboutput;
    where var = 'tau'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=tau_mean; /* Rename mean to tau_mean for clarity */
run;

data phi_means;
    set Oboutput;
    where var = 'phi'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=phi_mean; /* Rename mean to tau_mean for clarity */
run;

/* Step 2: Merge the tau mean values back to the original dataset and calculate mean_s for var='beta1' */

/*merge tau_means and Oboutput_S*/
data Oboutput_S;
	merge Oboutput(in=a) tau_means(in=b) phi_means(in=c);
	if a; /* Keep all rows from original dataset */

	if var='beta1' then do;

		beta1_mean_s_bywhino = mean/(1 / sqrt(tau_mean));
		beta1_mean_s_byresid = mean/((1/sqrt(tau_mean))/sqrt(1-(phi_mean)**2));

		z_value = mean / sd;
		sd_whino = 1 / sqrt(tau_mean);
		sd_resid = sd_whino / sqrt(1-(phi_mean)**2);

		stderr_s_bywhino = sd/sd_whino;
		stderr_s_byresid = sd/sd_resid;

		stderr_s_bywhino_bc = sd*(1-3/(4*(&t-3)-1))/sd_whino;
		stderr_s_byresid_bc = sd*(1-3/(4*(&t-3)-1))/sd_resid;
	end;

	if var= 'phi' then do;
		z_value = mean/sd;
	end;

	drop tau_mean phi_mean;  
run;

/* Hedges' correction */

data Oboutput_S_BC;
	set Oboutput_S;
	beta1_mean_s_bywhino_bc =  beta1_mean_s_bywhino * (1-3/(4*(&t-3)-1));
	beta1_mean_s_byresid_bc = beta1_mean_s_byresid * (1-3/(4*(&t-3)-1));
run;

/* data aggregation and appending results */

data Baye_S1_11;
	set Oboutput_S_BC;
	dataset=&a;
	gamma000=&gamma000;	
	gamma100=&gamma100; 
	T=&t; 
	rho=&rho;
run;

proc append base=results.Bayesian_s1_11 new=Baye_s1_11 FORCE NOWARN;
quit;

%end; 

/****************************************
* Bayesian estimation: Stage 1 (12) 
****************************************/

%let filepath = /network/rit/lab/moeyaertlab/yx/dec2024/yx/logS1.txt;
/*%let filepath = Z:/yx/bayeresultYX_S1_noJ/logS1.txt;*/

/* Goal: Delete the log file if it exists */

%macro delete_file(filepath);
    %local rc fileref rc_delete;
    %let fileref = delref;

/* Assign the fileref to the file path */
%let rc = %sysfunc(filename(fileref, &filepath));

%if %sysfunc(fexist(&fileref)) %then %do;
	%let rc_delete = %sysfunc(fdelete(&fileref));
	%if &rc_delete = 0 %then 
		%put File deleted successfully.;
    %else 
		%put File deletion failed. RC=&rc_delete;
%end;

%else 
	%put File does not exist, no need to delete.;

/* Clear the fileref */
%let rc = %sysfunc(filename(fileref));
%mend delete_file;

/* run the macro */
%delete_file(&filepath);

/* run the code for Bayesian estimation */

%include '/network/rit/lab/moeyaertlab/yx/dec2024/yx/ob_s1_12.sas';

data OBoutput;
	set temp_Bayes_S1; 
run;

/* standardization */

/* Step 1: Create a dataset with mean values for tau */

data tau_means;
	set Oboutput;
    where var = 'tau'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=tau_mean; /* Rename mean to tau_mean for clarity */
run;

data phi_means;
    set Oboutput;
    where var = 'phi'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=phi_mean; /* Rename mean to tau_mean for clarity */
run;

/* Step 2: Merge the tau mean values back to the original dataset and calculate mean_s for var='beta1' */

/*merge tau_means and Oboutput_S*/
data Oboutput_S;
	merge Oboutput(in=a) tau_means(in=b) phi_means(in=c);
	if a; /* Keep all rows from original dataset */

	if var='beta1' then do;

		beta1_mean_s_bywhino = mean/(1 / sqrt(tau_mean));
		beta1_mean_s_byresid = mean/((1/sqrt(tau_mean))/sqrt(1-(phi_mean)**2));

		z_value = mean / sd;
		sd_whino = 1 / sqrt(tau_mean);
		sd_resid = sd_whino / sqrt(1-(phi_mean)**2);

		stderr_s_bywhino = sd/sd_whino;
		stderr_s_byresid = sd/sd_resid;

		stderr_s_bywhino_bc = sd*(1-3/(4*(&t-3)-1))/sd_whino;
		stderr_s_byresid_bc = sd*(1-3/(4*(&t-3)-1))/sd_resid;
	end;

	if var= 'phi' then do;
		z_value = mean/sd;
	end;

	drop tau_mean phi_mean;  
run;

/* Hedges' correction */

data Oboutput_S_BC;
	set Oboutput_S;
	beta1_mean_s_bywhino_bc =  beta1_mean_s_bywhino * (1-3/(4*(&t-3)-1));
	beta1_mean_s_byresid_bc = beta1_mean_s_byresid * (1-3/(4*(&t-3)-1));
run;

/* data aggregation and appending results */

data Baye_S1_12;
	set Oboutput_S_BC;
	dataset=&a;
	gamma000=&gamma000;	
	gamma100=&gamma100; 
	T=&t; 
	rho=&rho;
run;

proc append base=results.Bayesian_s1_12 new=Baye_s1_12 FORCE NOWARN;
quit;

%end; 


/****************************************
* Bayesian estimation: Stage 1 (21) 
****************************************/

%let filepath = /network/rit/lab/moeyaertlab/yx/dec2024/yx/logS1.txt;
/*%let filepath = Z:/yx/bayeresultYX_S1_noJ/logS1.txt;*/

/* Goal: Delete the log file if it exists */

%macro delete_file(filepath);
    %local rc fileref rc_delete;
    %let fileref = delref;

/* Assign the fileref to the file path */
%let rc = %sysfunc(filename(fileref, &filepath));

%if %sysfunc(fexist(&fileref)) %then %do;
	%let rc_delete = %sysfunc(fdelete(&fileref));
	%if &rc_delete = 0 %then 
		%put File deleted successfully.;
    %else 
		%put File deletion failed. RC=&rc_delete;
%end;

%else 
	%put File does not exist, no need to delete.;

/* Clear the fileref */
%let rc = %sysfunc(filename(fileref));
%mend delete_file;

/* run the macro */
%delete_file(&filepath);

/* run the code for Bayesian estimation */

%include '/network/rit/lab/moeyaertlab/yx/dec2024/yx/ob_s1_21.sas';

data OBoutput;
	set temp_Bayes_S1; 
run;

/* standardization */

/* Step 1: Create a dataset with mean values for tau */

data tau_means;
	set Oboutput;
    where var = 'tau'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=tau_mean; /* Rename mean to tau_mean for clarity */
run;

data phi_means;
    set Oboutput;
    where var = 'phi'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=phi_mean; /* Rename mean to tau_mean for clarity */
run;

/* Step 2: Merge the tau mean values back to the original dataset and calculate mean_s for var='beta1' */

/*merge tau_means and Oboutput_S*/
data Oboutput_S;
	merge Oboutput(in=a) tau_means(in=b) phi_means(in=c);
	if a; /* Keep all rows from original dataset */

	if var='beta1' then do;

		beta1_mean_s_bywhino = mean/(1 / sqrt(tau_mean));
		beta1_mean_s_byresid = mean/((1/sqrt(tau_mean))/sqrt(1-(phi_mean)**2));

		z_value = mean / sd;
		sd_whino = 1 / sqrt(tau_mean);
		sd_resid = sd_whino / sqrt(1-(phi_mean)**2);

		stderr_s_bywhino = sd/sd_whino;
		stderr_s_byresid = sd/sd_resid;

		stderr_s_bywhino_bc = sd*(1-3/(4*(&t-3)-1))/sd_whino;
		stderr_s_byresid_bc = sd*(1-3/(4*(&t-3)-1))/sd_resid;
	end;

	if var= 'phi' then do;
		z_value = mean/sd;
	end;

	drop tau_mean phi_mean;  
run;

/* Hedges' correction */

data Oboutput_S_BC;
	set Oboutput_S;
	beta1_mean_s_bywhino_bc =  beta1_mean_s_bywhino * (1-3/(4*(&t-3)-1));
	beta1_mean_s_byresid_bc = beta1_mean_s_byresid * (1-3/(4*(&t-3)-1));
run;

/* data aggregation and appending results */

data Baye_S1_21;
	set Oboutput_S_BC;
	dataset=&a;
	gamma000=&gamma000;	
	gamma100=&gamma100; 
	T=&t; 
	rho=&rho;
run;

proc append base=results.Bayesian_s1_21 new=Baye_s1_21 FORCE NOWARN;
quit;

%end; 

/****************************************
* Bayesian estimation: Stage 1 (22) 
****************************************/

%let filepath = /network/rit/lab/moeyaertlab/yx/dec2024/yx/logS1.txt;
/*%let filepath = Z:/yx/bayeresultYX_S1_noJ/logS1.txt;*/

/* Goal: Delete the log file if it exists */

%macro delete_file(filepath);
    %local rc fileref rc_delete;
    %let fileref = delref;

/* Assign the fileref to the file path */
%let rc = %sysfunc(filename(fileref, &filepath));

%if %sysfunc(fexist(&fileref)) %then %do;
	%let rc_delete = %sysfunc(fdelete(&fileref));
	%if &rc_delete = 0 %then 
		%put File deleted successfully.;
    %else 
		%put File deletion failed. RC=&rc_delete;
%end;

%else 
	%put File does not exist, no need to delete.;

/* Clear the fileref */
%let rc = %sysfunc(filename(fileref));
%mend delete_file;

/* run the macro */
%delete_file(&filepath);

/* run the code for Bayesian estimation */

%include '/network/rit/lab/moeyaertlab/yx/dec2024/yx/ob_s1_22.sas';

data OBoutput;
	set temp_Bayes_S1; 
run;

/* standardization */

/* Step 1: Create a dataset with mean values for tau */

data tau_means;
	set Oboutput;
    where var = 'tau'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=tau_mean; /* Rename mean to tau_mean for clarity */
run;

data phi_means;
    set Oboutput;
    where var = 'phi'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=phi_mean; /* Rename mean to tau_mean for clarity */
run;

/* Step 2: Merge the tau mean values back to the original dataset and calculate mean_s for var='beta1' */

/*merge tau_means and Oboutput_S*/
data Oboutput_S;
	merge Oboutput(in=a) tau_means(in=b) phi_means(in=c);
	if a; /* Keep all rows from original dataset */

	if var='beta1' then do;

		beta1_mean_s_bywhino = mean/(1 / sqrt(tau_mean));
		beta1_mean_s_byresid = mean/((1/sqrt(tau_mean))/sqrt(1-(phi_mean)**2));

		z_value = mean / sd;
		sd_whino = 1 / sqrt(tau_mean);
		sd_resid = sd_whino / sqrt(1-(phi_mean)**2);

		stderr_s_bywhino = sd/sd_whino;
		stderr_s_byresid = sd/sd_resid;

		stderr_s_bywhino_bc = sd*(1-3/(4*(&t-3)-1))/sd_whino;
		stderr_s_byresid_bc = sd*(1-3/(4*(&t-3)-1))/sd_resid;
	end;

	if var= 'phi' then do;
		z_value = mean/sd;
	end;

	drop tau_mean phi_mean;  
run;

/* Hedges' correction */

data Oboutput_S_BC;
	set Oboutput_S;
	beta1_mean_s_bywhino_bc =  beta1_mean_s_bywhino * (1-3/(4*(&t-3)-1));
	beta1_mean_s_byresid_bc = beta1_mean_s_byresid * (1-3/(4*(&t-3)-1));
run;

/* data aggregation and appending results */

data Baye_S1_22;
	set Oboutput_S_BC;
	dataset=&a;
	gamma000=&gamma000;	
	gamma100=&gamma100; 
	T=&t; 
	rho=&rho;
run;

proc append base=results.Bayesian_s1_22 new=Baye_s1_22 FORCE NOWARN;
quit;

%end; 

/****************************************
* Bayesian estimation: Stage 1 (31) 
****************************************/

%let filepath = /network/rit/lab/moeyaertlab/yx/dec2024/yx/logS1.txt;
/*%let filepath = Z:/yx/bayeresultYX_S1_noJ/logS1.txt;*/

/* Goal: Delete the log file if it exists */

%macro delete_file(filepath);
    %local rc fileref rc_delete;
    %let fileref = delref;

/* Assign the fileref to the file path */
%let rc = %sysfunc(filename(fileref, &filepath));

%if %sysfunc(fexist(&fileref)) %then %do;
	%let rc_delete = %sysfunc(fdelete(&fileref));
	%if &rc_delete = 0 %then 
		%put File deleted successfully.;
    %else 
		%put File deletion failed. RC=&rc_delete;
%end;

%else 
	%put File does not exist, no need to delete.;

/* Clear the fileref */
%let rc = %sysfunc(filename(fileref));
%mend delete_file;

/* run the macro */
%delete_file(&filepath);

/* run the code for Bayesian estimation */

%include '/network/rit/lab/moeyaertlab/yx/dec2024/yx/ob_s1_31.sas';

data OBoutput;
	set temp_Bayes_S1; 
run;

/* standardization */

/* Step 1: Create a dataset with mean values for tau */

data tau_means;
	set Oboutput;
    where var = 'tau'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=tau_mean; /* Rename mean to tau_mean for clarity */
run;

data phi_means;
    set Oboutput;
    where var = 'phi'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=phi_mean; /* Rename mean to tau_mean for clarity */
run;

/* Step 2: Merge the tau mean values back to the original dataset and calculate mean_s for var='beta1' */

/*merge tau_means and Oboutput_S*/
data Oboutput_S;
	merge Oboutput(in=a) tau_means(in=b) phi_means(in=c);
	if a; /* Keep all rows from original dataset */

	if var='beta1' then do;

		beta1_mean_s_bywhino = mean/(1 / sqrt(tau_mean));
		beta1_mean_s_byresid = mean/((1/sqrt(tau_mean))/sqrt(1-(phi_mean)**2));

		z_value = mean / sd;
		sd_whino = 1 / sqrt(tau_mean);
		sd_resid = sd_whino / sqrt(1-(phi_mean)**2);

		stderr_s_bywhino = sd/sd_whino;
		stderr_s_byresid = sd/sd_resid;

		stderr_s_bywhino_bc = sd*(1-3/(4*(&t-3)-1))/sd_whino;
		stderr_s_byresid_bc = sd*(1-3/(4*(&t-3)-1))/sd_resid;
	end;

	if var= 'phi' then do;
		z_value = mean/sd;
	end;

	drop tau_mean phi_mean;  
run;

/* Hedges' correction */

data Oboutput_S_BC;
	set Oboutput_S;
	beta1_mean_s_bywhino_bc =  beta1_mean_s_bywhino * (1-3/(4*(&t-3)-1));
	beta1_mean_s_byresid_bc = beta1_mean_s_byresid * (1-3/(4*(&t-3)-1));
run;

/* data aggregation and appending results */

data Baye_S1_31;
	set Oboutput_S_BC;
	dataset=&a;
	gamma000=&gamma000;	
	gamma100=&gamma100; 
	T=&t; 
	rho=&rho;
run;

proc append base=results.Bayesian_s1_31 new=Baye_s1_31 FORCE NOWARN;
quit;

%end; 

/****************************************
* Bayesian estimation: Stage 1 (32) 
****************************************/

%let filepath = /network/rit/lab/moeyaertlab/yx/dec2024/yx/logS1.txt;
/*%let filepath = Z:/yx/bayeresultYX_S1_noJ/logS1.txt;*/

/* Goal: Delete the log file if it exists */

%macro delete_file(filepath);
    %local rc fileref rc_delete;
    %let fileref = delref;

/* Assign the fileref to the file path */
%let rc = %sysfunc(filename(fileref, &filepath));

%if %sysfunc(fexist(&fileref)) %then %do;
	%let rc_delete = %sysfunc(fdelete(&fileref));
	%if &rc_delete = 0 %then 
		%put File deleted successfully.;
    %else 
		%put File deletion failed. RC=&rc_delete;
%end;

%else 
	%put File does not exist, no need to delete.;

/* Clear the fileref */
%let rc = %sysfunc(filename(fileref));
%mend delete_file;

/* run the macro */
%delete_file(&filepath);

/* run the code for Bayesian estimation */

%include '/network/rit/lab/moeyaertlab/yx/dec2024/yx/ob_s1_32.sas';

data OBoutput;
	set temp_Bayes_S1; 
run;

/* standardization */

/* Step 1: Create a dataset with mean values for tau */

data tau_means;
	set Oboutput;
    where var = 'tau'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=tau_mean; /* Rename mean to tau_mean for clarity */
run;

data phi_means;
    set Oboutput;
    where var = 'phi'; /* Filter only rows where var is tau */
    keep mean; /* Keep only necessary variables */
    rename mean=phi_mean; /* Rename mean to tau_mean for clarity */
run;

/* Step 2: Merge the tau mean values back to the original dataset and calculate mean_s for var='beta1' */

/*merge tau_means and Oboutput_S*/
data Oboutput_S;
	merge Oboutput(in=a) tau_means(in=b) phi_means(in=c);
	if a; /* Keep all rows from original dataset */

	if var='beta1' then do;

		beta1_mean_s_bywhino = mean/(1 / sqrt(tau_mean));
		beta1_mean_s_byresid = mean/((1/sqrt(tau_mean))/sqrt(1-(phi_mean)**2));

		z_value = mean / sd;
		sd_whino = 1 / sqrt(tau_mean);
		sd_resid = sd_whino / sqrt(1-(phi_mean)**2);

		stderr_s_bywhino = sd/sd_whino;
		stderr_s_byresid = sd/sd_resid;

		stderr_s_bywhino_bc = sd*(1-3/(4*(&t-3)-1))/sd_whino;
		stderr_s_byresid_bc = sd*(1-3/(4*(&t-3)-1))/sd_resid;
	end;

	if var= 'phi' then do;
		z_value = mean/sd;
	end;

	drop tau_mean phi_mean;  
run;

/* Hedges' correction */

data Oboutput_S_BC;
	set Oboutput_S;
	beta1_mean_s_bywhino_bc =  beta1_mean_s_bywhino * (1-3/(4*(&t-3)-1));
	beta1_mean_s_byresid_bc = beta1_mean_s_byresid * (1-3/(4*(&t-3)-1));
run;

/* data aggregation and appending results */

data Baye_S1_32;
	set Oboutput_S_BC;
	dataset=&a;
	gamma000=&gamma000;	
	gamma100=&gamma100; 
	T=&t; 
	rho=&rho;
run;

proc append base=results.Bayesian_s1_32 new=Baye_s1_32 FORCE NOWARN;
quit;

%end; 

/****************************************
* REML estimation: Stage 1  
****************************************/

proc mixed data=raw method=reml covtest;
   by case;
   class case;
   model y = D / solution ddfm=kenwardroger;
   repeated / subject=case type=ar(1);
   
   ods output SolutionF=uncorrected1 CovParms=covariance;
run;


data MSE1;
   set covariance end=last; *end=last is used to ensure only one final row is output;

   retain case MS RMSE rho_unc rho_se rho_z_value rho_p;

   if covparm = 'Residual' then do;
    MS = Estimate;
   	RMSE = sqrt(Estimate);
   end;

   if covparm = 'AR(1)' then do;
       rho_unc = Estimate;
       rho_se = StdErr; /* Standard Error for AR(1) */
	   rho_z_value = ZValue;
	   rho_p = ProbZ;
   end;

   if last then output;
   keep case MS RMSE rho_unc rho_se rho_z_value rho_p;
run;

data MSE2;
   set MSE1;
   rho_cheang=rho_unc*((&t-2)/(&t-4));

   rho_se_cheang = rho_se *((&t-2)/(&t-4));

   if rho_cheang < -1 then rho_cheang_adj = -1;
   else if rho_cheang > 1 then rho_cheang_adj = 1;
   else rho_cheang_adj = rho_cheang; 

   sd_whino_unc = RMSE *sqrt(1-(rho_unc)**2) ;
   sd_whino_cheang = RMSE *sqrt(1-(rho_unc)**2)*sqrt(&t/(&t-1)) ;

run;


/* standardization */

data uncorrected2;
   merge uncorrected1 MSE2; 
   by case; 
run;

data corrected;
	set uncorrected2;
	where Effect = 'D' ;

	StdErr_byresid_bc = StdErr*(1-3/(4*(&t-3)-1))/RMSE;
	StdErr_bywhino_unc_bc = StdErr*(1-3/(4*(&t-3)-1))/sd_whino_unc;
	StdErr_bywhino_cheang_bc = StdErr*(1-3/(4*(&t-3)-1))/sd_whino_cheang;

	precision = 1/(StdErr*StdErr);

	precisionS_byresid=MS/(StdErr*StdErr);
	precisionS_byresid_bc=MS/((StdErr*StdErr)*((1-3/(4*(&t-3)-1))**2)); 

	estimateS_byresid=estimate/(RMSE);
	estimateS_byresidl_bc=estimateS_byresid*(1-3/(4*(&t-3)-1));

	precisionS_bywhino_unc=(sd_whino_unc**2)/(StdErr*StdErr);
	precisionS_bywhino_unc_bc=(sd_whino_unc**2)/((StdErr*StdErr)*((1-3/(4*(&t-3)-1))**2));

	estimateS_bywhino_unc=estimate/(sd_whino_unc);
	estimateS_bywhino_unc_bc=estimateS_bywhino_unc*(1-3/(4*(&t-3)-1));

	precisionS_bywhino_cheang=(sd_whino_cheang**2)/(StdErr*StdErr);
	precisionS_bywhino_cheang_bc=(sd_whino_cheang**2)/((StdErr*StdErr)*((1-3/(4*(&t-3)-1))**2));

	estimateS_bywhino_cheang=estimate/(sd_whino_cheang);
	estimateS_bywhino_cheang_bc=estimateS_bywhino_cheang*(1-3/(4*(&t-3)-1));

run;


proc sort data=Corrected;
   by case;
run;


data freq_S1; 
  set Corrected (rename=(estimate=D));
run;

/* data aggregation and appending results */

data freq_S1;
	set freq_S1;

	dataset=&a;
	gamma000=&gamma000;	
	gamma100=&gamma100; 
	T=&t; 
	rho=&rho;
run;

proc append base=results.frequentist_S1 new=freq_S1 force nowarn;
quit;

%end; /*loop d*/
%end; /*loop c*/
%end; /*loop b*/
%end; /*loop a*/

%mend aera;

%aera;
quit;

proc printto; run;


