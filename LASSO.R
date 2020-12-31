# This is an example code using LASSO to conduct variable selection

.libPaths(c(.libPaths(),"c:/3.5"))
library(polywog)
library(glmnet)
library(caret)


county = read.csv("\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Data\\Development\\2_Covariate selection\\COUNTY.csv",header=T)
county <- county[ which(county$LIT_SRE_P1 >0), ]

#county <- county[ which(county$PSUID >=0) ,]
# "PCT_BLACK_NOHISP","PCT_ASIAN_NOHISP"

pred.log = c("PCT_EDU_LESS_HS","PCT_EDU_HS","PCT_EDU_MORE_HS","PCT_PVT_BELOW_100","SNAP","PCT_PVT_BELOW_150",
             "ALL_AGE_PVT_PCT","LOG_ACS_MEDIAN_INC","LOG_MEDIAN_HH_INCOME","PCT_ENG_NOT_WELL","PCT_OTHER_LANG",
             "Metro_2013","PCT_HISP","PCT_BLACK","PCT_ASIAN","PCT_NATIVE_A","PCT_NHPI",
             "PCT_OTHER_RACE","PCT_foreign_5","PCT_foreign_6_20","PCT_foreign_LS_20","PCT_foreign_MO_21","PCT_born_out_US",
             "PCT_AGE_16_54", "PCT_AGE_55_64","PCT_AGE_65_UP","PCT_MALE","Unemployment_rate_2015",
             "PCT_EMP_ARMED","PCT_LAB_EMP","PCT_LAB_UNEMP","PCT_NOT_LAB","PCT_OCP_MGT","PCT_OCP_SER","PCT_OCP_SALE",
             "PCT_OCP_NAT_RS_MANT","PCT_OCP_MILITARY","PCT_OCP_PROD","PCT_WORK_30","PCT_WORK_30_44","PCT_WORK_45_59",
             "PCT_WORK_60UP","PCT_owner_OCP","PCT_rent_OCP","PCT_OWN_PHONE_SRV","PCT_RENT_PHONE_SRV","PCT_HU_OCP",
             "PCT_HH_PLUMB","PCT_NEVER_MARRIED","PCT_MARRIED","PCT_WIDOWED","PCT_DIVORCED","PCT_DIFF_HOUSE",
             "PCT_DIFF_COUNTY","PCT_DIFF_STATE","PCT_DIFF_ABROAD","PCT_1_HLTH_INS","PCT_2_HLTH_INS","PCT_NO_HLTH_INS",
             "PCT_DIAG_DIABETE","PCT_OBESITY","Pct_Eligible_for_Medicaid","PCT_R_ALL","PCT_R_UNEMP", "PCT_R_SSB", 
             "PCT_A_UNEMP", "PCT_A_SSB","RUCC_1","RUCC_23","RUCC_49","division_1","division_2","division_3",
             "division_4","division_5","division_6","division_7","division_8","division_9","PSUPROB","Annual_Wage_Per_Employee",
             "HOS_RR_15","infant_mort_rate","ACT_PHYSICIAN_RATE","Fata_Rates_100_Mill_Veh_Mil_Trav","birth_rate",
             "fert_rate","age_mom_15_19_tot","READ_GRADE4_SCORE","READ_GRADE8_SCORE","MATH_GRADE4_SCORE","MATH_GRADE8_SCORE",
             "cmpl_1st_13_cohort_RATE","Violent_crime","GRRTTOT","TUFEYR3","GRNTA2","SAAVMNT","abe_rate","ase_rate",
             "esl_rate","pct_tot_aid","pct_revenue","pct_eng")
pred.log.9 = c("PCT_EDU_LESS_HS","PCT_EDU_HS","PCT_EDU_MORE_HS","PCT_PVT_BELOW_100","SNAP",
               "LOG_ACS_MEDIAN_INC","PCT_ENG_NOT_WELL",
               "Metro_2013","PCT_HISP","PCT_BLACK","PCT_ASIAN","PCT_NATIVE_A","PCT_NHPI",
               "PCT_OTHER_RACE","PCT_foreign_5","PCT_foreign_6_20","PCT_foreign_LS_20","PCT_foreign_MO_21",
               "PCT_AGE_16_54", "PCT_AGE_55_64","PCT_AGE_65_UP","PCT_MALE","Unemployment_rate_2015",
               "PCT_EMP_ARMED","PCT_LAB_EMP","PCT_LAB_UNEMP","PCT_NOT_LAB","PCT_OCP_MGT","PCT_OCP_SER","PCT_OCP_SALE",
               "PCT_OCP_NAT_RS_MANT","PCT_OCP_PROD","PCT_WORK_30","PCT_WORK_30_44","PCT_WORK_45_59",
               "PCT_WORK_60UP","PCT_owner_OCP","PCT_HU_OCP",
               "PCT_HH_PLUMB","PCT_MARRIED","PCT_NEVER_MARRIED","PCT_WIDOWED","PCT_DIVORCED","PCT_DIFF_HOUSE",
               "PCT_DIFF_COUNTY","PCT_DIFF_STATE","PCT_DIFF_ABROAD","PCT_1_HLTH_INS","PCT_2_HLTH_INS","PCT_NO_HLTH_INS",
               "PCT_DIAG_DIABETE","PCT_OBESITY","Pct_Eligible_for_Medicaid","PCT_R_ALL","PCT_R_UNEMP", "PCT_R_SSB", 
               "PCT_A_SSB","RUCC_1","RUCC_23","RUCC_49","division_1","division_2","division_3",
               "division_4","division_5","division_6","division_7","division_8","division_9", "PSUPROB","Annual_Wage_Per_Employee",
               "HOS_RR_15","infant_mort_rate","ACT_PHYSICIAN_RATE","Fata_Rates_100_Mill_Veh_Mil_Trav","birth_rate",
               "fert_rate","age_mom_15_19_tot","READ_GRADE4_SCORE","READ_GRADE8_SCORE","MATH_GRADE4_SCORE","MATH_GRADE8_SCORE",
               "cmpl_1st_13_cohort_RATE","Violent_crime","GRRTTOT","TUFEYR3","GRNTA2","SAAVMNT","abe_rate","ase_rate",
               "esl_rate","pct_tot_aid","pct_revenue","pct_eng","PCT_born_out_US")

pred.log.8 = c("PCT_EDU_LESS_HS","PCT_EDU_MORE_HS","PCT_PVT_BELOW_100",
               "LOG_ACS_MEDIAN_INC","PCT_ENG_NOT_WELL",
               "Metro_2013","PCT_HISP","PCT_BLACK","PCT_ASIAN","PCT_NATIVE_A","PCT_NHPI",
               "PCT_OTHER_RACE","PCT_foreign_5","PCT_foreign_6_20","PCT_foreign_LS_20","PCT_foreign_MO_21",
               "PCT_AGE_16_54", "PCT_AGE_55_64", "PCT_MALE","Unemployment_rate_2015",
               "PCT_EMP_ARMED","PCT_LAB_UNEMP","PCT_NOT_LAB","PCT_OCP_SER","PCT_OCP_SALE",
               "PCT_OCP_NAT_RS_MANT","PCT_OCP_PROD","PCT_WORK_30_44","PCT_WORK_45_59",
               "PCT_WORK_60UP","PCT_owner_OCP","PCT_HU_OCP",
               "PCT_HH_PLUMB","PCT_MARRIED","PCT_WIDOWED","PCT_DIVORCED","PCT_DIFF_HOUSE",
               "PCT_DIFF_COUNTY","PCT_DIFF_STATE","PCT_DIFF_ABROAD","PCT_1_HLTH_INS","PCT_2_HLTH_INS","PCT_NO_HLTH_INS",
               "PCT_DIAG_DIABETE","PCT_OBESITY","Pct_Eligible_for_Medicaid","PCT_R_ALL","PCT_R_UNEMP", "PCT_R_SSB", 
               "RUCC_1","RUCC_23","RUCC_49","division_1","division_2","division_3",
               "division_4","division_5","division_6","division_7","division_8","division_9","PSUPROB","Annual_Wage_Per_Employee",
               "HOS_RR_15","infant_mort_rate","ACT_PHYSICIAN_RATE","Fata_Rates_100_Mill_Veh_Mil_Trav","birth_rate",
               "fert_rate","age_mom_15_19_tot","READ_GRADE4_SCORE","READ_GRADE8_SCORE","MATH_GRADE4_SCORE","MATH_GRADE8_SCORE",
               "cmpl_1st_13_cohort_RATE","Violent_crime","GRRTTOT","TUFEYR3","GRNTA2","SAAVMNT","abe_rate","ase_rate",
               "esl_rate","pct_tot_aid","pct_revenue","pct_eng","PCT_born_out_US")
pred.log.7 = c("PCT_EDU_LESS_HS","PCT_EDU_MORE_HS","PCT_PVT_BELOW_100",
               "PCT_ENG_NOT_WELL",
               "Metro_2013","PCT_HISP","PCT_BLACK","PCT_ASIAN","PCT_NATIVE_A","PCT_NHPI",
               "PCT_OTHER_RACE","PCT_foreign_5","PCT_foreign_6_20",
               "PCT_AGE_55_64","PCT_AGE_65_UP","PCT_MALE","Unemployment_rate_2015",
               "PCT_EMP_ARMED","PCT_LAB_UNEMP","PCT_OCP_SER","PCT_OCP_SALE",
               "PCT_OCP_NAT_RS_MANT","PCT_OCP_PROD","PCT_WORK_30_44","PCT_WORK_45_59",
               "PCT_WORK_60UP","PCT_owner_OCP","PCT_HU_OCP",
               "PCT_HH_PLUMB","PCT_DIVORCED","PCT_DIFF_HOUSE",
               "PCT_DIFF_COUNTY","PCT_DIFF_STATE","PCT_2_HLTH_INS","PCT_NO_HLTH_INS",
               "PCT_DIAG_DIABETE","PCT_R_ALL","PCT_R_UNEMP",  
               "RUCC_1","RUCC_49","division_1","division_2","division_3",
               "division_4","division_5","division_6","division_7","division_8","division_9","PSUPROB","Annual_Wage_Per_Employee",
               "HOS_RR_15","infant_mort_rate","ACT_PHYSICIAN_RATE","Fata_Rates_100_Mill_Veh_Mil_Trav","birth_rate",
               "fert_rate","age_mom_15_19_tot","READ_GRADE4_SCORE","READ_GRADE8_SCORE","MATH_GRADE4_SCORE","MATH_GRADE8_SCORE",
               "cmpl_1st_13_cohort_RATE","Violent_crime","GRRTTOT","TUFEYR3","GRNTA2","SAAVMNT","abe_rate","ase_rate",
               "esl_rate","pct_tot_aid","pct_revenue","pct_eng","PCT_born_out_US")


x.log<-data.matrix(county[pred.log])
x.log.9<-data.matrix(county[pred.log.9])
x.log.8<-data.matrix(county[pred.log.8])
x.log.7<-data.matrix(county[pred.log.7])

y<-data.matrix(county[c("LIT_SRE_P1","LIT_SRE_P2","LIT_SRE_P3")])
y2<-data.matrix(county[c("LIT_SRE_P1","LIT_SRE_P3")])
y_a<-data.matrix(county[c("Lit_sre_mean")])


#multivariate LASSO for proportion P1, P2 & P3
mfit = glmnet(x.log,y, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit= cv.glmnet(x.log, y, family = "mgaussian")
cvmfit$lambda.min
#cvmfit$lambda.1se 
c_m<- coef(cvmfit, s=cvmfit$lambda.min)
Lit_p_all_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P2_coefficient = c_m[[2]]@x,P3_coefficient = c_m[[3]]@x )
c_2<- coef(cvmfit, s=0.02)
Lit_p_all_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P2_coefficient = c_2[[2]]@x,P3_coefficient = c_2[[3]]@x )
c_3<- coef(cvmfit, s=0.03)
Lit_p_all_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P2_coefficient = c_3[[2]]@x,P3_coefficient = c_3[[3]]@x )
c_4<- coef(cvmfit, s=0.04)
Lit_p_all_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P2_coefficient = c_4[[2]]@x,P3_coefficient = c_4[[3]]@x )


mfit.9 = glmnet(x.log.9,y, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit.9= cv.glmnet(x.log.9, y, family = "mgaussian")
cvmfit.9$lambda.min
c_m<-coef(cvmfit.9, s=cvmfit.9$lambda.min)
Lit_p_9_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P2_coefficient = c_m[[2]]@x,P3_coefficient = c_m[[3]]@x )
c_2<- coef(cvmfit.9, s=0.02)
Lit_p_9_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P2_coefficient = c_2[[2]]@x,P3_coefficient = c_2[[3]]@x )
c_3<- coef(cvmfit.9, s=0.03)
Lit_p_9_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P2_coefficient = c_3[[2]]@x,P3_coefficient = c_3[[3]]@x )
c_4<- coef(cvmfit.9, s=0.04)
Lit_p_9_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P2_coefficient = c_4[[2]]@x,P3_coefficient = c_4[[3]]@x )

mfit.8 = glmnet(x.log.8,y, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit.8= cv.glmnet(x.log.8, y, family = "mgaussian")
cvmfit.8$lambda.min
c_m<- coef(cvmfit.8, s=cvmfit.8$lambda.min)
Lit_p_8_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P2_coefficient = c_m[[2]]@x,P3_coefficient = c_m[[3]]@x )
c_2<- coef(cvmfit.8, s=0.02)
Lit_p_8_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P2_coefficient = c_2[[2]]@x,P3_coefficient = c_2[[3]]@x )
c_3<- coef(cvmfit.8, s=0.03)
Lit_p_8_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P2_coefficient = c_3[[2]]@x,P3_coefficient = c_3[[3]]@x )
c_4<- coef(cvmfit.8, s=0.04)
Lit_p_8_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P2_coefficient = c_4[[2]]@x,P3_coefficient = c_4[[3]]@x )


mfit.7 = glmnet(x.log.7,y, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit.7= cv.glmnet(x.log.7, y, family = "mgaussian")
cvmfit.7$lambda.min
c_m<- coef(cvmfit.7, s=cvmfit.7$lambda.min)
Lit_p_7_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P2_coefficient = c_m[[2]]@x,P3_coefficient = c_m[[3]]@x )
c_2<- coef(cvmfit.7, s=0.02)
Lit_p_7_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P2_coefficient = c_2[[2]]@x,P3_coefficient = c_2[[3]]@x )
c_3<- coef(cvmfit.7, s=0.03)
Lit_p_7_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P2_coefficient = c_3[[2]]@x,P3_coefficient = c_3[[3]]@x )
c_4<- coef(cvmfit.7, s=0.04)
Lit_p_7_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P2_coefficient = c_4[[2]]@x,P3_coefficient = c_4[[3]]@x )


#######  multivariate LASSO for proportion with only P1 & P3  
mfit = glmnet(x.log,y2, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit= cv.glmnet(x.log, y2, family = "mgaussian")
cvmfit$lambda.min
c_m<- coef(cvmfit, s=cvmfit$lambda.min)
Lit_p2_all_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P3_coefficient = c_m[[2]]@x)
c_2<- coef(cvmfit, s=0.02)
Lit_p2_all_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P3_coefficient = c_2[[2]]@x)
c_3<- coef(cvmfit, s=0.03)
Lit_p2_all_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P3_coefficient = c_3[[2]]@x)
c_4<- coef(cvmfit, s=0.04)
Lit_p2_all_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P3_coefficient = c_4[[2]]@x)

mfit.9 = glmnet(x.log.9,y2, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit.9= cv.glmnet(x.log.9, y2, family = "mgaussian")
cvmfit.9$lambda.min
c_m<- coef(cvmfit.9, s=cvmfit.9$lambda.min)
Lit_p2_9_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P3_coefficient = c_m[[2]]@x)
c_2<- coef(cvmfit.9, s=0.02)
Lit_p2_9_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P3_coefficient = c_2[[2]]@x)
c_3<- coef(cvmfit.9, s=0.03)
Lit_p2_9_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P3_coefficient = c_3[[2]]@x)
c_4<- coef(cvmfit.9, s=0.04)
Lit_p2_9_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P3_coefficient = c_4[[2]]@x)

mfit.8 = glmnet(x.log.8,y2, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit.8= cv.glmnet(x.log.8, y2, family = "mgaussian")
cvmfit.8$lambda.min
c_m<- coef(cvmfit.8, s=cvmfit.8$lambda.min)
Lit_p2_8_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P3_coefficient = c_m[[2]]@x)
c_2<- coef(cvmfit.8, s=0.02)
Lit_p2_8_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P3_coefficient = c_2[[2]]@x)
c_3<- coef(cvmfit.8, s=0.03)
Lit_p2_8_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P3_coefficient = c_3[[2]]@x)
c_4<- coef(cvmfit.8, s=0.04)
Lit_p2_8_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P3_coefficient = c_4[[2]]@x)

mfit.7 = glmnet(x.log.7,y2, family = "mgaussian",standardize=TRUE,alpha=1)
cvmfit.7= cv.glmnet(x.log.7, y2, family = "mgaussian")
cvmfit.7$lambda.min
c_m<- coef(cvmfit.7, s=cvmfit.7$lambda.min)
Lit_p2_7_min<-data.frame(name = c_m[[1]]@Dimnames[[1]][c_m[[1]]@i + 1], P1_coefficient = c_m[[1]]@x,P3_coefficient = c_m[[2]]@x)
c_2<- coef(cvmfit.7, s=0.02)
Lit_p2_7_2<-data.frame(name = c_2[[1]]@Dimnames[[1]][c_2[[1]]@i + 1], P1_coefficient = c_2[[1]]@x,P3_coefficient = c_2[[2]]@x)
c_3<- coef(cvmfit.7, s=0.03)
Lit_p2_7_3<-data.frame(name = c_3[[1]]@Dimnames[[1]][c_3[[1]]@i + 1], P1_coefficient = c_3[[1]]@x,P3_coefficient = c_3[[2]]@x)
c_4<- coef(cvmfit.7, s=0.04)
Lit_p2_7_4<-data.frame(name = c_4[[1]]@Dimnames[[1]][c_4[[1]]@i + 1], P1_coefficient = c_4[[1]]@x,P3_coefficient = c_4[[2]]@x)

# Single LASSO for average
fit=glmnet(x.log,y_a, family="gaussian",standardize=TRUE,alpha=1)
cvmfit<-cv.glmnet(x.log,y_a,family="gaussian",standardize=TRUE,alpha=1,nfolds=20 )
cvmfit$lambda.min
c_m<- coef(cvmfit, s=cvmfit$lambda.min)
Lit_average_all_min<-data.frame(name = c_m@Dimnames[[1]][c_m@i + 1], coefficient = c_m@x)
c_1<- coef(cvmfit, s=1)
Lit_average_all_1<-data.frame(name = c_1@Dimnames[[1]][c_1@i + 1], coefficient = c_1@x)
c_2<- coef(cvmfit, s=2)
Lit_average_all_2<-data.frame(name = c_2@Dimnames[[1]][c_2@i + 1], coefficient = c_2@x)
c_3<- coef(cvmfit, s=3)
Lit_average_all_3<-data.frame(name = c_3@Dimnames[[1]][c_3@i + 1], coefficient = c_3@x)

fit.9=glmnet(x.log.9,y_a, family="gaussian",standardize=TRUE,alpha=1)
cvmfit.9<-cv.glmnet(x.log.9,y_a,family="gaussian",standardize=TRUE,alpha=1,nfolds=20 )
cvmfit.9$lambda.min
c_m<-coef(cvmfit.9, s=cvmfit.9$lambda.min)
Lit_average_9_min<-data.frame(name = c_m@Dimnames[[1]][c_m@i + 1], coefficient = c_m@x)
c_1<-coef(cvmfit.9, s=1)
Lit_average_9_1<-data.frame(name = c_1@Dimnames[[1]][c_1@i + 1], coefficient = c_1@x)
c_2<-coef(cvmfit.9, s=2)
Lit_average_9_2<-data.frame(name = c_2@Dimnames[[1]][c_2@i + 1], coefficient = c_2@x)
c_3<-coef(cvmfit.9, s=3)
Lit_average_9_3<-data.frame(name = c_3@Dimnames[[1]][c_3@i + 1], coefficient = c_3@x)

fit.8=glmnet(x.log.8,y_a, family="gaussian",standardize=TRUE,alpha=1)
cvmfit.8<-cv.glmnet(x.log.8,y_a,family="gaussian",standardize=TRUE,alpha=1,nfolds=20 )
cvmfit.8$lambda.min
c_m<-coef(cvmfit.8, s=cvmfit.8$lambda.min)
Lit_average_8_min<-data.frame(name = c_m@Dimnames[[1]][c_m@i + 1], coefficient = c_m@x)
c_1<-coef(cvmfit.8, s=1)
Lit_average_8_1<-data.frame(name = c_1@Dimnames[[1]][c_1@i + 1], coefficient = c_1@x)
c_2<-coef(cvmfit.8, s=2)
Lit_average_8_2<-data.frame(name = c_2@Dimnames[[1]][c_2@i + 1], coefficient = c_2@x)
c_3<-coef(cvmfit.8, s=3)
Lit_average_8_3<-data.frame(name = c_3@Dimnames[[1]][c_3@i + 1], coefficient = c_3@x)

fit.7=glmnet(x.log.7,y_a, family="gaussian",standardize=TRUE,alpha=1)
cvmfit.7<-cv.glmnet(x.log.7,y_a,family="gaussian",standardize=TRUE,alpha=1,nfolds=20 )
cvmfit.7$lambda.min
c_m<-coef(cvmfit.7, s=cvmfit.7$lambda.min)
Lit_average_7_min<-data.frame(name = c_m@Dimnames[[1]][c_m@i + 1], coefficient = c_m@x)
c_1<-coef(cvmfit.7, s=1)
Lit_average_7_1<-data.frame(name = c_1@Dimnames[[1]][c_1@i + 1], coefficient = c_1@x)
c_2<-coef(cvmfit.7, s=2)
Lit_average_7_2<-data.frame(name = c_2@Dimnames[[1]][c_2@i + 1], coefficient = c_2@x)
c_3<-coef(cvmfit.7, s=3)
Lit_average_7_3<-data.frame(name = c_3@Dimnames[[1]][c_3@i + 1], coefficient = c_3@x)
c_4<-coef(cvmfit.7, s=4)
Lit_average_7_4<-data.frame(name = c_4@Dimnames[[1]][c_4@i + 1], coefficient = c_4@x)

# Output the results
library(xlsx)

# 3 Proportions
write.xlsx(Lit_p_all_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", sheetName="All_min", row.names=FALSE)
write.xlsx(Lit_p_all_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="All_0.02", row.names=FALSE)
write.xlsx(Lit_p_all_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="All_0.03", row.names=FALSE)
write.xlsx(Lit_p_all_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="All_0.04", row.names=FALSE)
write.xlsx(Lit_p_9_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx",append=TRUE, sheetName="cor0.9_min", row.names=FALSE)
write.xlsx(Lit_p_9_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.9_0.02", row.names=FALSE)
write.xlsx(Lit_p_9_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.9_0.03", row.names=FALSE)
write.xlsx(Lit_p_9_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.9_0.04", row.names=FALSE)
write.xlsx(Lit_p_8_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx",append=TRUE, sheetName="cor0.8_min", row.names=FALSE)
write.xlsx(Lit_p_8_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.8_0.02", row.names=FALSE)
write.xlsx(Lit_p_8_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.8_0.03", row.names=FALSE)
write.xlsx(Lit_p_8_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.8_0.04", row.names=FALSE)
write.xlsx(Lit_p_7_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx",append=TRUE, sheetName="cor0.7_min", row.names=FALSE)
write.xlsx(Lit_p_7_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.7_0.02", row.names=FALSE)
write.xlsx(Lit_p_7_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.7_0.03", row.names=FALSE)
write.xlsx(Lit_p_7_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_3prop_LASSO.xlsx", append=TRUE, sheetName="cor0.7_0.04", row.names=FALSE)

# 2 Proportions
write.xlsx(Lit_p2_all_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", sheetName="All_min", row.names=FALSE)
write.xlsx(Lit_p2_all_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="All_0.02", row.names=FALSE)
write.xlsx(Lit_p2_all_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="All_0.03", row.names=FALSE)
write.xlsx(Lit_p2_all_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="All_0.04", row.names=FALSE)
write.xlsx(Lit_p2_9_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx",append=TRUE, sheetName="cor0.9_min", row.names=FALSE)
write.xlsx(Lit_p2_9_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.9_0.02", row.names=FALSE)
write.xlsx(Lit_p2_9_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.9_0.03", row.names=FALSE)
write.xlsx(Lit_p2_9_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.9_0.04", row.names=FALSE)
write.xlsx(Lit_p2_8_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx",append=TRUE, sheetName="cor0.8_min", row.names=FALSE)
write.xlsx(Lit_p2_8_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.8_0.02", row.names=FALSE)
write.xlsx(Lit_p2_8_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.8_0.03", row.names=FALSE)
write.xlsx(Lit_p2_8_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.8_0.04", row.names=FALSE)
write.xlsx(Lit_p2_7_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx",append=TRUE, sheetName="cor0.7_min", row.names=FALSE)
write.xlsx(Lit_p2_7_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.7_0.02", row.names=FALSE)
write.xlsx(Lit_p2_7_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.7_0.03", row.names=FALSE)
write.xlsx(Lit_p2_7_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_2prop_LASSO.xlsx", append=TRUE, sheetName="cor0.7_0.04", row.names=FALSE)

# Averages
write.xlsx(Lit_average_all_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", sheetName="All_min", row.names=FALSE)
write.xlsx(Lit_average_all_1, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="All_1", row.names=FALSE)
write.xlsx(Lit_average_all_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="All_2", row.names=FALSE)
write.xlsx(Lit_average_all_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="All_3", row.names=FALSE)
write.xlsx(Lit_average_9_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.9_min", row.names=FALSE)
write.xlsx(Lit_average_9_1, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.9_1", row.names=FALSE)
write.xlsx(Lit_average_9_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.9_2", row.names=FALSE)
write.xlsx(Lit_average_9_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.9_3", row.names=FALSE)
write.xlsx(Lit_average_8_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.8_min", row.names=FALSE)
write.xlsx(Lit_average_8_1, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.8_1", row.names=FALSE)
write.xlsx(Lit_average_8_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.8_2", row.names=FALSE)
write.xlsx(Lit_average_8_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.8_3", row.names=FALSE)
write.xlsx(Lit_average_7_min, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.7_min", row.names=FALSE)
write.xlsx(Lit_average_7_1, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.7_1", row.names=FALSE)
write.xlsx(Lit_average_7_2, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.7_2", row.names=FALSE)
write.xlsx(Lit_average_7_3, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.7_3", row.names=FALSE)
write.xlsx(Lit_average_7_4, file="\\\\westat.com\\dfs\\PIAAC2013\\SAE\\Programs\\Development\\2_Covariate selection\\Literacy\\Literacy_Average_LASSO.xlsx", append=TRUE, sheetName="cor0.7_4", row.names=FALSE)




