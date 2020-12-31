####  This is the Random Forest Model   

library(partykit)
# random forest
lf1 = formula(paste("LIT_SRE_P1"," ~ ", paste(pred.log, collapse=" + ")))
lf2 = formula(paste("LIT_SRE_P2"," ~ ", paste(pred.log, collapse=" + ")))
lf3 = formula(paste("LIT_SRE_P3"," ~ ", paste(pred.log, collapse=" + ")))
lfa = formula(paste("lit_sre_mean"," ~ ", paste(pred.log, collapse=" + ")))
nf1 = formula(paste("NUM_SRE_P1"," ~ ", paste(pred.log, collapse=" + ")))
nf2 = formula(paste("NUM_SRE_P2"," ~ ", paste(pred.log, collapse=" + ")))
nf3 = formula(paste("NUM_SRE_P3"," ~ ", paste(pred.log, collapse=" + ")))
nfa = formula(paste("NUM_sre_mean"," ~ ", paste(pred.log, collapse=" + ")))

set.seed(4543)
clf1<- cforest(lf1, data=county)
varimp(clf1,conditional=TRUE)
clf2<- cforest(lf2, data=county)
varimp(clf2,conditional=TRUE)
clf3<- cforest(lf3, data=county)
varimp(clf3,conditional=TRUE)
clfa<- cforest(lfa, data=county)
varimp(clfa,conditional=TRUE)

cnf1<- cforest(nf1, data=county)
varimp(cnf1,conditional=TRUE)
cnf2<- cforest(nf2, data=county)
varimp(cnf2,conditional=TRUE)
cnf3<- cforest(nf3, data=county)
varimp(cnf3,conditional=TRUE)
cnfa<- cforest(nfa, data=county)
varimp(cnfa,conditional=TRUE)


