FILENAME REFFILE '/folders/myfolders/EtudeDeCasBioStat/TECCOsujet3_Vannes.xlsx';

PROC IMPORT REPLACE DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.DATA;
	GETNAMES=YES;
RUN;

proc format;
	value ouinon
					0='NON'
					1='OUI';
	value sexe
					1='HOMME'
					2='FEMME';
	value groupe
					0='endovasculaire'
					1='chirurgical';
	value anesthesie
					1='locale'
					2='générale'
					3='loco-régionale';
run;

data data;
	SET data;
	
	LABEL SUBJID = "n° identifiant patient";
	
	if libellegrouperando='endovasculaire' then GROUPE=0;
	if libellegrouperando='chirurgical' then GROUPE=1;
	LABEL GROUPE='Groupe';
	FORMAT GROUPE groupe.;
	DROP libellegrouperando;
	
	AGE=YEAR(DATEPROCEDURE)-YEAR(datedenaissance);
	LABEL AGE='Âge lors de la procédure';
	DROP DATEPROCEDURE;
	DROP datedenaissance;
	
	if sexe='HOMME' then GENRE=1;
	if sexe='FEMME' then GENRE=2;
	LABEL GENRE='Genre';
	FORMAT GENRE sexe.;
	DROP sexe;
	
	FORMAT tabac ouinon.;
	
	if HTA="OUI" then HYPERTENSION=1;
	if HTA="NON" then HYPERTENSION=0;
	LABEL HYPERTENSION="Hypertension artérielle";
	FORMAT HYPERTENSION ouinon.;
	DROP HTA;
	
	if diabète="OUI" then DIABETE=1;
	if diabète="NON" then DIABETE=0;
	LABEL DIABETE="Diabète";
	FORMAT DIABETE ouinon.;
	DROP diabète;
	
	if insuffisancerénalechronique="1" then IRC=1;
	if insuffisancerénalechronique="0" then IRC=0;
	LABEL IRC="Insuffisance rénale chronique";
	FORMAT IRC ouinon.;
	DROP insuffisancerénalechronique;
	
	FORMAT Dyslipidemie ouinon.;
	FORMAT atcdAVCAIT ouinon.;
	LABEL atcdAVCAIT="antécédent d'Accident vasculaire cerebral";
	FORMAT atcdchirurgicauxvasculaires ouinon.;
	LABEL atcdchirurgicauxvasculaires="antécédent de chirurgie vasculaire";
	FORMAT antiagregantplaquettairepreinclu ouinon.;
	LABEL antiagregantplaquettairepreinclu="antiagregant plaquettaire à l'inclusion";
	FORMAT clopidogrelpreinclusion ouinon.;
	LABEL clopidogrelpreinclusion="clopidogrel à l'inclusion";
	FORMAT aspirinepreinclusion ouinon.;
	LABEL aspirinepreinclusion="asprine à l'inclusion";
	FORMAT IECpreinclusion ouinon.;
	LABEL IECpreinclusion="IEC à l'inclusion";
	FORMAT statinepreinclusion ouinon.;
	LABEL statinepreinclusion="Statine à l'inclusion";
	FORMAT AVKpreinclusion ouinon.;
	LABEL AVKpreinclusion="AVK à l'inclusion";
	LABEL IPSpre = "IPS à J0";
	LABEL rutherfordpreinclusion = "classification de Rutherford à l'inclusion";
	LABEL IMC="IMC à J0";
	
	if anesthesie="locale" then ANES=1;
	if anesthesie="générale" then ANES=2;
	if anesthesie="loco-régionale" then ANES=3;
	LABEL ANES="Type d'anesthésie durant l'intervention";
	FORMAT ANES anesthesie.;
	DROP anesthesie;
	
	IF rutherfordpreinclusion=2 then RJ0_1=1;
	else RJ0_1=0;
	LABEL RJ0_1='Claudication modérée';
	FORMAT RJ0_1 ouinon.;
	
	IF rutherfordpreinclusion=3 then RJ0_2=1;
	else RJ0_2=0;
	LABEL RJ0_2='Claudication sévère';
	FORMAT RJ0_2 ouinon.;
	
	IF rutherfordpreinclusion=4 then RJ0_3=1;
	else RJ0_3=0;
	LABEL RJ0_3='Douleurs au repos';
	FORMAT RJ0_3 ouinon.;
	
	IF rutherfordpreinclusion=5 then RJ0_4=1;
	else RJ0_4=0;
	LABEL RJ0_4='Perte de tissu mineure (ulcère ischémique)';
	FORMAT RJ0_4 ouinon.;
	

	
	if AmCliniqueP="NO" then ACP=0;
	if AmCliniqueP="YES" then ACP=1;
	LABEL ACP="Amélioration Clinique Primaire";
	FORMAT ACP ouinon.;
	DROP AmCliniqueP;
	
run;

proc means data=data min q1 median q3 max;
var AGE IMC IPSPre;
run;

data data;
	SET data;
	
	if AGE<=64 then AGE_1=1;
	else AGE_1=0;
	LABEL AGE_1="Âge lors de la procédure inférieur ou égal à 64";
	FORMAT AGE_1 ouinon.;
	
	if 64<AGE<=69 then AGE_2=1;
	else AGE_2=0;
	LABEL AGE_2="Âge lors de la procédure dans ]64;69]";
	FORMAT AGE_2 ouinon.;
	
	if 69<AGE<=74 then AGE_3=1;
	else AGE_3=0;
	LABEL AGE_3="Âge lors de la procédure dans ]69;74]";
	FORMAT AGE_3 ouinon.;
	
	if AGE>64 then AGE_4=1;
	else AGE_4=0;
	LABEL AGE_4="Âge lors de la procédure supérieur à 74";
	FORMAT AGE_4 ouinon.;
	
	if IMC<=23.53 then IMC_1=1;
	else IMC_1=0;
	LABEL IMC_1="IMC à J0 inférieure à 23.53";
	FORMAT IMC_1 ouinon.;
	
	if 23.53<IMC<=26.03 then IMC_2=1;
	else IMC_2=0;
	LABEL IMC_2="IMC à J0 dans ]23.53;26.03]";
	FORMAT IMC_2 ouinon.;

	if 26.03<IMC<=29.07 then IMC_3=1;
	else IMC_3=0;
	LABEL IMC_3="IMC à J0 dans ]26.03;29.07]";
	FORMAT IMC_3 ouinon.;
	
	if IMC>29.07 then IMC_4=1;
	else IMC_4=0;
	LABEL IMC_4="IMC à J0 supérieure à 29.07";
	FORMAT IMC_4 ouinon.;
	
	if IPSPre<=0.525 then IPSPre_1=1;
	else IPSPre_1=0;
	LABEL IPSPre_1="IPS à J0 inférieure à 0.525";
	FORMAT IPSPre_1 ouinon.;
	
	if 0.525<IPSPre<=0.65 then IPSPre_2=1;
	else IPSPre_2=0;
	LABEL IPSPre_2="IMC à J0 dans ]0;525;0.65]";
	FORMAT IPSPre_2 ouinon.;
	
	if 0.65<IPSPre<=0.78 then IPSPre_3=1;
	else IPSPre_3=0;
	LABEL IPSPre_3="IMC à J0 dans ]0;65;0.78]";
	FORMAT IPSPre_3 ouinon.;
	
	if IPSPre>0.78 then IPSPre_4=1;
	else IPSPre_4=0;
	LABEL IPSPre_4="IPS à J0 supérieure à 0.78";
	FORMAT IPSPre_4 ouinon.;
	
run;

/*Tableau résumé variables qualitatives*/
PROC TABULATE data=data;
	CLASS GENRE DIABETE tabac HYPERTENSION IRC Dyslipidemie atcdAVCAIT atcdchirurgicauxvasculaires antiagregantplaquettairepreinclu clopidogrelpreinclusion
	aspirinepreinclusion IECpreinclusion statinepreinclusion AVKpreinclusion ANES AGE_1 AGE_2 AGE_3 AGE_4 IMC_1 IMC_2 IMC_3 IMC_4 RJ0_1 RJ0_2 RJ0_3 RJ0_4 IPSPre_1 IPSPre_2 IPSPre_3 IPSPre_4 ACP GROUPE;
	TABLE (GENRE DIABETE tabac HYPERTENSION IRC Dyslipidemie atcdAVCAIT atcdchirurgicauxvasculaires antiagregantplaquettairepreinclu clopidogrelpreinclusion
	aspirinepreinclusion IECpreinclusion statinepreinclusion AVKpreinclusion ANES AGE_1 AGE_2 AGE_3 AGE_4 IMC_1 IMC_2 IMC_3 IMC_4 RJ0_1 RJ0_2 RJ0_3 RJ0_4 IPSPre_1 IPSPre_2 IPSPre_3 IPSPre_4 ACP), (GROUPE)*(N COLPCTN);
	
run;
	
	
/*Chi_2*/
ODS OUTPUT chisq=chi2;
PROC FREQ data=data;

TABLE (GENRE DIABETE tabac HYPERTENSION IRC Dyslipidemie atcdAVCAIT atcdchirurgicauxvasculaires antiagregantplaquettairepreinclu clopidogrelpreinclusion
	aspirinepreinclusion IECpreinclusion statinepreinclusion AVKpreinclusion ANES AGE_1 AGE_2 AGE_3 AGE_4 IMC_1 IMC_2 IMC_3 IMC_4 RJ0_1 RJ0_2 RJ0_3 RJ0_4 IPSPre_1 IPSPre_2 IPSPre_3 IPSPre_4 ACP)*(GROUPE)/chisq;
	run;

data chi2;
set chi2;
if Statistic="Khi-2" then output;
run;
proc print data=chi2;
var table prob;
run;

/*Tableau résumé variables qualitatives*/
PROC TABULATE data=data;
	CLASS GROUPE;
	VAR AGE IMC rutherfordpreinclusion IPSPre;
	TABLE  (mean std min q1 median q3 max), (AGE IMC rutherfordpreinclusion IPSPre)*(GROUPE);
RUN;

*Chi_2;
ODS OUTPUT chisq=chi2;
PROC FREQ data=data;
TABLE (AGE IMC rutherfordpreinclusion IPSPre)*GROUPE/chisq;
RUN;
data chi2_2;
set chi2;
if Statistic="Khi-2" then output;
run;
proc print data=chi2_2;
var table prob;
run;

/*Graphiques*/
%let var = GENRE DIABETE tabac HYPERTENSION IRC Dyslipidemie atcdAVCAIT atcdchirurgicauxvasculaires antiagregantplaquettairepreinclu clopidogrelpreinclusion
	aspirinepreinclusion IECpreinclusion statinepreinclusion AVKpreinclusion ANES ACP AGE_1 AGE_2 AGE_3 AGE_4 IMC_1 IMC_2 IMC_3 IMC_4 RJ0_1 RJ0_2 RJ0_3 RJ0_4 IPSPre_1 IPSPre_2 IPSPre_3 IPSPre_4;
%macro barplot;
%do i = 1 %to 32;
%let variable = %scan(&var,&i);
proc sgplot data=data;
 vbar GROUPE / group=&variable groupdisplay=cluster;
 yaxis grid;
run;
%end;
%mend barplot;
%barplot;

/*Analyse univariée*/
%let var=GENRE DIABETE AGE rutherfordpreinclusion tabac HYPERTENSION IRC Dyslipidemie atcdAVCAIT atcdchirurgicauxvasculaires antiagregantplaquettairepreinclu clopidogrelpreinclusion
	aspirinepreinclusion IECpreinclusion statinepreinclusion AVKpreinclusion ANES;

PROC LOGISTIC DATA=data DESCENDING;
	CLASS GROUPE;
	MODEL ACP=GROUPE;
RUN;


%macro univar;
%do i = 1 %to 17;
%let variable = %scan(&var,&i);
PROC LOGISTIC data=data descending;
class &variable;
model ACP=&variable;
run;
%end;
%mend univar;
%univar;

/*rutherfordpreinclusion, atcdAVCAIT, AVKpreinclusion, ANES retenues pour l'analyse multivariée*/

/*PROC LOGISTIC DATA=DATA DESCENDING;
	CLASS RJ0_1 RJ0_2 RJ0_3 RJ0_4;
	MODEL ACP = RJ0_2 RJ0_3 RJ0_4/r1;
RUN;*/

%let var=GENRE DIABETE AGE rutherfordpreinclusion tabac HYPERTENSION IRC Dyslipidemie atcdAVCAIT atcdchirurgicauxvasculaires antiagregantplaquettairepreinclu clopidogrelpreinclusion
	aspirinepreinclusion IECpreinclusion statinepreinclusion AVKpreinclusion ANES;
%macro od;
%do i = 1 %to 17;
%let variable = %scan(&var,&i);
proc logistic data=DATA descending;
class &variable;
model ACP=&variable/rl;
run;
%end;
%mend od;
%od;

/*Analyse multivariée*/
proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion ANES;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion ANES;
run;

proc logistic data=DATA descending;
class GROUPE atcdAVCAIT AVKpreinclusion ANES;
model ACP = GROUPE atcdAVCAIT AVKpreinclusion ANES;
run;
/*'un des betas varie de plus de 10% rutherfordpreinclusion est donc un facteur de confusion, nous le gardons dans le modèle.*/

proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
run;
/*Aucun beta ne varie de plus de 10%, on peut donc retirer ANES du modèle*/

/*Analyse multivariée*/
proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion AVKpreinclusion ANES;
model ACP = GROUPE rutherfordpreinclusion AVKpreinclusion ANES;
run;
/*'un des betas varie de plus de 10% atcdAVCAIT est donc un facteur de confusion, nous le gardons dans le modèle.*/

/*Test d'interaction*/
proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion rutherfordpreinclusion*GROUPE;
run;

proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion atcdAVCAIT*GROUPE;
run;

proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion AVKpreinclusion*GROUPE;
run;

proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion AVKpreinclusion*rutherfordpreinclusion;
run;

proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion AVKpreinclusion*atcdAVCAIT;
run;

proc logistic data=DATA descending;
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion rutherfordpreinclusion*atcdAVCAIT;
run;

/*Adequation du modèle*/
proc logistic data=DATA descending plots(only)=roc(id=obs);
class GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion;
model ACP = GROUPE rutherfordpreinclusion atcdAVCAIT AVKpreinclusion / lackfit;
run;
