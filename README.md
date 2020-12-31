## Introduction 


With the increasing richness of data from multiple sources, the size of the pool of potential variables is escalating. Some variables, however, could provide redundant information, add noise to the estimation, or waste the degree of freedom in the model. Therefore, variable selection is needed as a parsimonious process that aims to identify a minimal set of predictors for maximum predictive power. 

This study illustrates the variable selection methods considered and used in the small area estimation (SAE) modeling of measures related to the proficiency of adult competency, constructed using survey data collected in the first cycle of PIAAC. The developed variable selection process consists of two phases: 

-Phase 1 identifies a small set of variables that are consistently highly correlated with the outcomes through methods such as correlation matrix and multivariate LASSO analysis; 

-Phase 2 utilizes a k-fold cross-validation process to select a final set of variables to be used in the final SAE models.

## Traditional variable selection methods

Traditional variable selection methods which are commonly applied in linear and generalized linear models include:

(1) significance criteria: likelihood ratio test (or Wald test), and stepwise (forward or backward) variable selection algorithms;             
(2) information criteria: Akaike information criterion (AIC) and Bayesian information criterion (BIC);            
(3) regularization criteria: least angle selection and shrinkage operator (LASSO) (Tibshirani, 1997);             
(4) association criteria: decision trees, random forests (Breiman et al., 1984);            
(5) cross-validation criteria (Shao, 1993); and             
(6) expert-knowledge criteria. 

There is, however, no single universally applicable variable selection method that fits all models, especially when the target models are complex. 

## Two-phase variable selection method

In this project, we describe the variable selection process adopted for the National Center for Education Statistics’ (NCES’s) Program for the International Assessment of Adult Competencies (PIAAC) of the U.S. The goal was to identify and select the best set of dependent variables to be used in the SAE models developed for estimating adult competency outcomes. A two-phase variable selection process is proposed: 

1. Phase 1: reduce the variables to a smaller set;          
2. Phase 2: use a k-fold cross-validation process to arrive at the final set of variables. 

[](VS_SAE.png)


### Phase 1 - variable reduction


The variable reduction process in phase 1 is consisted of two major steps: (1) data preparation and (2) variable pool reduction.

*Step 1.*  In the variable selection process, appropriate data preparation is needed before any variable selection algorithm kicks in. In the data preparation step, four data check processes are proposed to ensure the data are well prepared. 

1. First, the variables need to be carefully evaluated for redundancy. In this step, if two variables are found to be redundant, one will be dropped based on level of availability or multicollinearity issues. 

2. After examining redundancy, we want to identify outliers and influential cases by checking the distributions of the variables as well as the outcomes. Outliers and influential cases could have great impact in the variable selection, especially when the sample size is small. 

3. In addition to outlier detection, the skewness and kurtosis of each variable will be checked, and plots can be created to evaluate whether transformation is needed. Common transformation methods include standardization, reciprocal, logarithm, square root, squaring or taking nth power, and categorization/dichotomization, etc. 

4. Finally, a correlation matrix among the variables themselves as well as with the outcomes will be created to identify possible multicollinearity among variables. Variables with high correlations (i.e., 0.7 or 0.8, depending on the data) with another variable are identified as a “highly correlated” pair, and one variable from each pair will be eliminated from the variable pool based on its correlation with the outcome variable and other variables. 

*Step 2.* Once the data are well prepared in step 1, a suitable variable pool reduction method will be applied to reduce the number of variables further. Several steps are needed:

1. Identify the number of variables needed. This is usually captured by the events-per-variable (EPV) ratio. This is the ratio between the number of observations on the outcome variable and the number of variables included in the model. The EPV ratio quantifies the balance between the amount of information provided by the data and the number of unknown parameters that could be estimated. As a rule of thumb, the EPV ratio could range from 5 to 50, depending on the variables considered and models being developed (Harrell et al., 1984; Harrell, 2015; Austin et al., 2017). 

2. Use multivariate LASSO algorithm for the variable selection. The LASSO method was selected because of its applicability to multivariate model structure, which is the structure of the target model. LASSO (Tibshirani, 1997) is a method that applies shrinkage factors to regression coefficients, and thus can more efficiently perform stable variable selection. The procedure can select a few variables that are related to the dependent variable from a large amount of possible variables. LASSO-based methods use “penalized regression” models that impose constraints on the estimated coefficients that tend to shrink the magnitude of the regression coefficients, often eliminating the variables entirely by shrinking their coefficients to zero. Therefore, nonzero coefficients are estimated for true variables, whereas the coefficients for irrelevant variables are zeroed out. LASSO estimation is highly dependent on the scale of the covariates; therefore, LASSO performs an internal standardization to unit variance first, before the coefficients shrinkage takes place. The final variable reduction process was based on applying the LASSO model with standardized covariates and LASSO penalty. Package `glmnet` is used for LASSO modeling. 

Other methods are also explored, including stepwise regression and random forest. Results are similar to the LASSO selection, since the other two methods didn't apply to multivariate models, we stick to the LASSO results. It should be noted, however, that if the results from different methods have large discrepancy, this might indicate potential issues in the data, for example, random forest might detect interaction terms and is more robust to outlier, while LASSO only explores the main effect, and is not robust to outliers in continuous variable. If the results from random forest is very different from LASSO, we might want to consider to categorize the continous variables, or add in the interaction terms in LASSO models. 


### Phase 2 - variable reduction

It is possible that the relationship between a variable and the outcome from a simple additive model might change in the complex model. Therefore, it would be risky to directly use the selected variables from a selection algorithm in the final models.

From phase 1, we arrive at several sets of variables, in each set, different variables are included. These sets of candidate variables thus need to be evaluated in phase 2, where a cross-validation process takes place. In this phase, complex models with all the features of the final model could be applied. The final selected set of variables would be the one with decent predictive power, and presumably interpretable. 

The k-fold cross validation is implemented in the following steps, to select the best set of variables for the bivariate model of literacy proportions: 

-	We sort the sampled counties from the largest to the smallest by sample size, and divide them into groups of 10 counties, with the last group having only 4 counties. There are 19 groups in total.
-	For each group of 10 counties, the counties are randomly assigned to 10 subsets, with each subset containing 1 county from the group. For the group with 4 counties, the counties are randomly assigned to four subsets. At the end of this step, each subset contains 18 or 19 counties with varying sample sizes.
-	Excluding the counties in the first subset, the counties in the remaining nine subsets are used to fit the bivariate small area estimation model for each given set of variables and make predictions for the group of counties that are deleted.
-	The previous step is repeated by excluding subsets 2 through 10, one at a time. At the end of this process the predicted proportions at or below Level 1, at Level 2, and at or above Level 3 are calculated for all the counties.

We compare the predicted proportions against the observed estimates by using the sum of squared differences. The smaller the sum of squared differences are, the better the set of variables predict the proportions for the counties that are excluded from modeling. 

It should be noted that, variables found to be highly related to the outcomes from previous studies and literature should also be considered in addition to the variables selected by the algorithm. 





















