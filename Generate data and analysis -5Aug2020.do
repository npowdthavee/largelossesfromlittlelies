
import delimited "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/Combined raw data - lab.csv", clear

save "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/catfish_june2020.dta", replace
 

**Clean lab data

**Raw data summaries
//#1.

lab def treatment 0 "Control" 1 "True gender" 2 "Catfish endo" 3 "Catfish exog", modify
lab val treatment treatment 

lab def decision 0 "Split" 1 "Steal", modify
lab val decision decision
lab val othersdecision decision

**gen diff in decision
//#2.
 
gen paired_decision = 0 if decision == 0 & othersdecision == 0
replace paired_decision = 1 if decision == 0 & othersdecision == 1
replace paired_decision = 2 if decision == 1 & othersdecision == 0
replace paired_decision = 3 if decision == 1 & othersdecision ==1

lab def paired_decision 0 "Both split" 1 "One split, other steal" 2 "One steal, other split" 3 "Both steal", modify
lab val paired_decision paired_decision

lab def gender 1 "Male" 2 "Female", modify
lab val gender gender


gen both_steal = 0
replace both_steal = 1 if paired_decision==2


gen one_steal_other_split = 0
replace one_steal_other_split = 1 if decision == 1 & othersdecision==0

gen one_split_other_steal = 0
replace one_split_other_steal = 1 if decision == 0 & othersdecision==1

gen both_split = 0
replace both_split = 1 if paired_decision==0




**Catfish: Do people who lied also steal?
//#3.
**Catfish: Do people who lied also steal?
 

gen misrepresented_gender = 0 if treatment==0
replace misrepresented_gender = 1 if treatment==1 
replace misrepresented_gender = 2 if reported_gender == 0 & treatment==2 
replace misrepresented_gender = 3 if reported_gender == gender & reported_gender>0 & treatment==2
replace misrepresented_gender = 4 if reported_gender ~= gender & reported_gender>0 & treatment==2
replace misrepresented_gender = 2 if type == 0 & treatment ==3
replace misrepresented_gender = 5 if type == 1 & gender == exog & treatment ==3
replace misrepresented_gender = 6 if type == 1 & gender ~= exog & treatment ==3


lab def misrepresented_gender 0 "Control" 1 "True gender" 2 "Paired with a potential catfish" 3 "Received opport, did not catfish" 4 "Catfished" /*
*/ 5 "Random/matched gender" 6 "Random/catfished", modify

lab val misrepresented_gender misrepresented_gender



**Treatment -- four groups
gen random_treatment = 0 if treatment==0
replace random_treatment = 1 if treatment==1
replace random_treatment = 2 if reported_gender == 0 & treatment==2 
replace random_treatment = 3 if reported_gender == gender & reported_gender>0 & treatment==2
replace random_treatment = 3 if reported_gender ~= gender & reported_gender>0 & treatment==2



**gender pairing
//#4.
 
gen gender_pairing = 0 if gender == 1 & othersgender==1
replace gender_pairing = 1 if gender==2 & othersgender==1
replace gender_pairing = 2 if gender==1 & othersgender==2
replace gender_pairing = 3 if gender==2 & othersgender==2

lab def gender_pairing 0 "Both males" 1 "Female matched w male" /*
*/ 2 "Male matched w female" 3 "Both females" , modify

lab val gender_pairing gender_pairing

gen econ = 0
replace econ = 1 if major=="Economics" 
replace econ = 1 if major=="Economics or Business"
replace econ = 1 if major=="economics"
replace econ = 1 if major=="Economics and Industrial Organization"

save "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/catfish_june2020.dta", replace
 


**Merge online with lab data

import delimited "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/GB Merged Data.csv", clear

 
gen online=1
 
replace treatment =  treatment-1
 
encode gender, generate(gender_)
 
drop gender
 
encode reported_gender, generate(reported_gender_) 
drop reported_gender
ren reported_gender_ reported_gender
 
encode partner_gender, generate(partner_gender_)
drop partner_gender  
 
ren misrepresented_gender mis_rep

encode decision, generate(decision_)
drop decision 
ren decision_ decision
replace decision = 0 if decision == 1
replace decision = 1 if decision == 2

append using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/catfish_june2020.dta", force

save  "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/catfish_final_june2020.dta", replace

**Adding the online subjects to the misrepresented_gender variable

replace misrep = 0 if online==1 & t1==1
replace misrep = 1 if online==1 & t2==1
replace misrep = 2 if online==1 & t3_or_t4_and_no_opp==1
replace misrep = 3 if online==1 & t3_and_chose_not_to_misrepresent==1
replace misrep = 4 if online==1 & mis_rep == "1"
replace misrep = 5 if online==1 & t4_randomised_and_match==1
replace misrep = 6 if online==1 & t4_randomised_and_no_match==1

replace decision = 0 if decision==0 & online==1
replace decision = 1 if decision==1 & online==1

lab def decision 0 "Split" 1 "Steal", modify
lab val decision decision

replace online = 0 if online==.

replace location = 2 if online==1
lab define location 0 "UK-Lab" 1 "SG-Lab" 2 "UK/US-Online", modify 
lab val location location

**Encode Dark Triad
encode tend_to_manipulate, gen(tend_to_manipulate_)
encode lied_to_get_ones_way, gen(lied_to_get_ones_way_)
encode flattery_to_get_ones_way, gen(flattery_to_get_ones_way_)
encode exploit_to_own_end, gen(exploit_to_own_end_)
encode lack_remorse, gen(lack_remorse_)
encode unconcerned_w_morality_of_action, gen(morality_of_action_)
encode callous_insensitive, gen(callous_insensitive_)
encode cynical, gen(cynical_)
encode desire_admiration, gen(desire_admiration_)
encode desire_attention, gen(desire_attention_)
encode desire_prestige_status, gen(desire_prestige_status_)
encode desire_special_favours, gen(desire_special_favours_)

replace personality1 = tend_to_manipulate_ if online==1
replace personality2 = lied_to_get_ones_way_ if online==1
replace personality3 = flattery_to_get_ones_way_ if online==1
replace personality4 = exploit_to_own_end_ if online==1
replace personality5 = lack_remorse_ if online==1
replace personality6 = morality_of_action_ if online==1
replace personality7 = callous_insensitive_ if online==1
replace personality8 = cynical_ if online==1
replace personality9 = desire_admiration_ if online==1
replace personality10 = desire_attention_ if online==1
replace personality11 = desire_prestige_status_ if online==1
replace personality12 = desire_special_favours_ if online==1

gen time_prisoner_dummy = 0 
replace time_prisoner_dummy = 1 if timeokprisonersdilemmaok==.
replace timeokprisonersdilemmaok = 99 if timeokprisonersdilemmaok==.

replace gender = 0 if gender ==2
replace econ = 0 if online==1

encode general_risk_appetite, gen(general_risk)

replace risk = general_risk if online==1

drop paired_decision

gen paired_decision = 0 if decision == 0 & othersdecision == 0
replace paired_decision = 1 if decision == 0 & othersdecision == 1
replace paired_decision = 2 if decision == 1 & othersdecision == 0
replace paired_decision = 3 if decision == 1 & othersdecision ==1

lab def paired_decision 0 "Both split" 1 "One split, other steal" 2 "One steal, other split" 3 "Both steal", modify
lab val paired_decision paired_decision

replace paired_decision = 0 if online==1 & payoff==10
replace paired_decision = 1 if online==1 & decision ==0 & payoff==0
replace paired_decision = 2 if online==1 & decision ==1 & payoff==20
replace paired_decision = 3 if online==1 & decision == 1 & payoff==0

gen age_sq = age^2

replace gender = 0 if gender_==1 & online==1
replace gender = 1 if gender_==2 & online==1

replace othersgender = 0 if othersgender==2
replace othersgender = 0 if partner_gender_==1 & online==1
replace othersgender = 1 if partner_gender_==2 & online==1

drop gender_pairing

gen gender_pairing = 0 if gender == 1 & othersgender==1
replace gender_pairing = 1 if gender==0 & othersgender==1
replace gender_pairing = 2 if gender==1 & othersgender==0
replace gender_pairing = 3 if gender==0 & othersgender==0

lab def gender_pairing1 0 "Both males" 1 "Female matched w male" /*
*/ 2 "Male matched w female" 3 "Both females" 

lab val gender_pairing gender_pairing1 

gen catfish = 0 if misrep == 3
replace catfish = 1 if misrep == 4

**Payment

gen payment = 0 if paired_decision == 3
replace payment = 0 if paired_decision == 1
replace payment = 10 if paired_decision == 0
replace payment = 20 if paired_decision == 2

gen zero_payment = 0
replace zero_payment = 1 if payment ==0

gen max_payment = 0
replace max_payment = 1 if payment ==20

**Misrepresented ver.2

gen m2 = misrep
replace m2 = 7 if m2==6
replace m2 = 6 if m2==5
replace m2 = 5 if treatment==3 & m2==2

lab def m2 0 "Blind" 1 "True gender" 2 "Did not receive opportunity to misrepresent" 3 "Randomly assigned opportunity, did not misrepresent" 4 "Misrepresented gender" /*
*/ 5 "Were not randomly assigned gender" 6 "Randomly assigned gender/matched gender" 7 "Randomly assigned gender/mismatched gender", modify

lab val m2 m2

gen control = 0
replace control = 1 if treatment==0
lab def control 1 "Control"
lab val control control
lab var  control "Control"
 
gen true_gender = 0
replace true_gender = 1 if treatment==1
lab def true_gender 1 "True gender"
lab val true_gender true_gender
lab var true_gender "True gender"

gen catfish1 = 0
replace catfish1 = 1 if m2==2
lab def catfish1 1 "Did not receive opportunit to misrepresent"
lab val catfish1 catfish1
lab var catfish1 "Did not receive opportunit to misrepresent"
 
gen catfish2 = 0
replace catfish2 = 1 if m2==3
lab def catfish2 1 "Randomly assigned opportunity, did not misrepresent"
lab val catfish2 catfish2
lab var catfish2 "Randomly assigned opportunity, did not misrepresent"

gen catfish3 = 0
replace catfish3 = 1 if m2==4
lab def catfish3 1 "Misrepresented gender'"
lab val catfish3 catfish3
lab var catfish3 "Misrepresented gender"

gen catfish4 = 0
replace catfish4 = 1 if m2==5
lab def catfish4 1 "Were not randomized gender"
lab val catfish4 catfish4
lab var catfish4 "Were not randomized gender"
 
gen catfish5 = 0
replace catfish5 = 1 if m2==6
lab def catfish5 1 "Randomized gender/matched"
lab val catfish5 catfish5
lab var catfish5 "Randomized gender/matched"

gen catfish6 = 0
replace catfish6 = 1 if m2==7
lab def catfish6 1 "Randomized gender/mismatched"
lab val catfish6 catfish6
lab var catfish6 "Randomized gender/mismatched"

gen m3 = m2
replace m3 = 3 if m3==4
replace m3 = 6 if m3==7

gen catfish_ITT = 0
replace catfish_ITT = 1 if m3==3


pca person* 

predict pc1 pc2 pc3 pc4, score

factor person* 
rotate
predict fc1 fc2 fc3 

pca risk*

predict rk1 rk2 rk3 rk4, score

**gen trust
encode trust, gen(trust_variable)

ren trust trust_n

gen trust = 0 if (trust_variable == 1 | trust_variable == 4)
replace trust = 1 if (trust_variable == 2 | trust_variable == 3)

 
encode general_trust_in_others, gen(t_1)

replace trust = 0 if t_1 == 3
replace trust = 1 if t_1 == 2

lab def trust 0 "You can't be too careful" 1 "Most people can be trusted", modify
lab val trust trust

replace othersdecision = 0 if online==1 & (paired_decision == 0 | paired_decision == 2)
replace othersdecision = 1 if online==1 & (paired_decision == 1 | paired_decision == 3)


**Generate c_outcome

gen c_outcome = 0 if catfish2==1
replace c_outcome = 1 if catfish3 == 1
 
	 	 	 	 
**Match catfishers to somebody who got catfished
sort session group

by session group: egen have_catfish = max(m2) 
replace have_catfish = . if have_catfish ~=4

by session group: egen no_catfish = max(m2) 
replace no_catfish = . if no_catfish ~=3

by session group: egen matched_gender = max(m2) 
replace matched_gender = . if matched_gender ~=6

by session group: egen mismatched_gender = max(m2) 
replace mismatched_gender = . if mismatched_gender ~=7


**Do people who played against catfishers steal more?

gen m4 = m2
replace m4 = 8 if have_catfish==4 & m4~=4
replace m4 = 9 if mismatched_gender==7 & m4~=7
probit decision i.m4 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok  risk   , r


**Compared SWB with different wins and losses

replace sat1 = life_close_to_ideal if online==1
replace sat2 = excellent_conditions_of_life if online==1
replace sat3 = satisfied_with_life if online==1
replace sat4 = got_important_things_in_life if online==1
replace sat5 = change_nothing if online==1

rename satisfied_with_life _satisfied_with_life

factor sat*

rotate

predict psat

tab payment, su(psat)

ranksum psat if payment<=10, by(payment)
ranksum psat if payment>=10, by(payment)

**Change in emotions
ren change_nothing _change_nothing

gen change_interested = interested_post-interested_pre
gen change_distressed = distressed_post-distressed_pre
gen change_excited = excited_post-excited_pre
gen change_upset = upset_post - upset_pre
gen change_strong = strong_post - strong_pre
gen change_guilty = guilty_post - guilty_pre
gen change_scared = scared_post - scared_pre
gen change_hostile = hostile_post - hostile_pre
gen change_enthusiastic = enthusiastic_post - enthusiastic_pre
gen change_proud = proud_post - proud_pre
gen change_irritable = irritable_post - irritable_pre
gen change_alert = alert_post - alert_pre
gen change_ashamed = ashamed_post - ashamed_pre
gen change_inspired = inspired_post - inspired_pre
gen change_nervous = nervous_post - nervous_pre
gen change_determined = determined_post - determined_pre

gen change_jittery = jittery_post - jittery_pre
gen change_active = active_post - active_pre
gen change_afraid = afraid_post - afraid_pre

factor change_*

rotate 

predict emotion1 emotion2

gen inter_cat3_gender = catfish3*gender 


**Factor analysis of Dark Triad

factor person*

rotate
 
save  "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/catfish_final_june2020.dta", replace


use "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/Science/Data files/catfish_final_june2020.dta", clear

 

-------
**Econ paper version



**Ranksum test

ranksum decision if (m2 == 0 | m2 == 4), by(m2)
ranksum decision if (m2 == 1 | m2 == 4), by(m2)



tabstat decision, by(m2) s(mean sd semean)


tabstat decision, by(m3) s(mean sd semean)

**Table 2
char m2[omit] 0
xi:dprobit decision i.m2 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok    , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS1_Aug20.xls", replace  
 
char m2[omit] 1
xi:dprobit decision i.m2 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok      , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS1_Aug20.xls", append  

char m2[omit] 0
xi:dprobit decision i.m2 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok  risk fc1 fc2  fc3 trust  , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS1_Aug20.xls", append 
 
char m2[omit] 1
xi:dprobit decision i.m2 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok  risk  fc1 fc2  fc3 trust , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS1_Aug20.xls", append  


**Table 3
**Table S3.
char m3[omit] 0
xi: dprobit decision i.m3 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok  risk  fc1 fc2  fc3 trust  , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS3_Aug20.xls", replace
char m3[omit] 1
xi:dprobit decision i.m3 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok  risk  fc1 fc2  fc3 trust  , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS3_Aug20.xls", append

char treat[omit] 0
xi:dprobit decision i.treatment i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok  risk  fc1 fc2  fc3 trust  , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS3_Aug20.xls", append

char treat[omit] 1
xi:dprobit decision i.treatment i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok  risk  fc1 fc2  fc3 trust  , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS3_Aug20.xls", append



**Comparing men (control) and women (catfish)

gen catfish_ITT = 0
replace catfish_ITT = 1 if m3==3

probit decision i.true_gender i.catfish1 i.catfish2 i.catfish3 i.gender inter_cat3 i.catfish4 i.catfish5  i.catfish6  age age_sq econ i.location  timeokprisonersdilemmaok  risk  risk  fc1 fc2  fc3 trust  , r
margins  r.gender r.catfish3 , post atmean
estimates store com1

coefplot com1, vertical recast(bar) barwidth(0.3) fcolor(*.5) nolabel ///
     ciopts(recast(rcap)) citop   format(%9.2f) ytitle("Marginal effect on the decision to steal") ///
     addplot(scatter @b @at, ms(i) mlabel(@b) mlabpos(2) mlabcolor(black))  

 

**Table S4.
char m2[omit] 0
xi:dprobit max_payment i.m2 i.gender_pair age age_sq econ i.location  timeokprisonersdilemmaok   risk  fc1 fc2  fc3 trust   , r  cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS4_Aug20.xls", replace

char m2[omit] 1
xi:dprobit max_payment i.m2 i.gender_pair age age_sq econ i.location  timeokprisonersdilemmaok  risk  fc1 fc2  fc3 trust   , r  cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS4_Aug20.xls", append


*Table S5.


char m2[omit] 0
xi:dprobit decision  i.m2 i.gender_pairing age age_sq  econ i.location  timeokprisonersdilemmaok   risk fc1 fc2  fc3 trust    if location==0, r  cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS5_Aug20.xls", replace
 
char m2[omit] 0
xi:dprobit decision  i.m2 i.gender_pairing age age_sq  econ i.location  timeokprisonersdilemmaok   risk  fc1 fc2  fc3 trust  if location==1, r  cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS5_Aug20.xls", append
 
char m2[omit] 0
xi:dprobit decision  i.m2 i.gender_pairing age age_sq  econ i.location  timeokprisonersdilemmaok   risk  fc1 fc2  fc3 trust  if location==2, r  
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS5_Aug20.xls", append

char m2[omit] 0
xi:dprobit decision  i.m2 i.gender_pairing age age_sq  econ i.location  timeokprisonersdilemmaok   risk  fc1 fc2  fc3 trust  if gender==0, r  cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS5_Aug20.xls", append
 
char m2[omit] 0
xi:dprobit decision  i.m2 i.gender_pairing age age_sq  econ i.location  timeokprisonersdilemmaok   risk  fc1 fc2  fc3 trust  if gender==1, r  cluster(session)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS5_Aug20.xls", append 
 


//By gender pairing

probit decision i.true_gender i.catfish1 i.catfish2 i.catfish3 i.catfish4 i.catfish5 i.catfish6 i.gender_pairing age age_sq econ i.location  timeokprisonersdilemmaok risk  risk  fc1 fc2  fc3 trust   if (gender_pairing==0 | gender_pairing == 3) , r cluster(session)
margins r.true_gender  r.catfish1  r.catfish2  r.catfish3 r.catfish4 r.catfish5 r.catfish6, post atmean
estimates store gender0

probit decision i.true_gender i.catfish1 i.catfish2 i.catfish3 i.catfish4 i.catfish5 i.catfish6 i.gender_pairing  age age_sq econ i.location  timeokprisonersdilemmaok risk  risk  fc1 fc2  fc3 trust   if (gender_pairing==1 | gender_pairing == 2) , r cluster(session)
margins r.true_gender  r.catfish1  r.catfish2  r.catfish3 r.catfish4 r.catfish5 r.catfish6, post atmean
estimates store gender1


   
*Fig S5.
coefplot  gender0, bylabel(Same gender, N=491) || gender1 , bylabel(Opposite gender, N=474) || /*
*/  , /*
*/ drop(_cons _Igend*   econ location  timeokprisonersdilemmaok person* pc1 pc2  rk*) /*
*/  xline(0) xtitle("Marginal effect on the decision to steal") byopts(compact cols(1))    


**Catfish equation

xi:dprobit c_outcome gender age age_sq  econ i.location   , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS6_Aug20.xls", replace

xi:dprobit c_outcome gender age age_sq  econ i.location  risk fc1 fc2 fc3 trust  , r cluster(session)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/TableS6_Aug20.xls", append
 

**Gini coefficients
ineqdec0 payment if m2==0
ineqdec0 payment if m2==1
ineqdec0 payment if no_catfish==3
ineqdec0 payment if have_catfish==4
ineqdec0 payment if matched_gender ==6
ineqdec0 payment if mismatched_gender==7

ineqdec0 payment if (no_catfish==3 | have_catfish==4)

**Testing SWB after payment

tab payment, su(emotion1)

tab payment, su(emotion2)

tab payment, su(psat)

ranksum emotion1 if payment<=10, by(payment)
ranksum emotion1 if payment>=10, by(payment)

ranksum emotion2 if payment<=10, by(payment)
ranksum emotion2 if payment>=10, by(payment)

xi:asdoc sum decision payment gender age econ risk trust   /*
*/ , by(location) stat(N mean semean min max) save(/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/mydoc1.doc) replace 

xi:asdoc sum decision payment gender age econ risk trust   /*
*/ ,  stat(N mean semean min max) save(/Users/nattavudhpowdthavee/Dropbox/Golden ball/Preparing manuscript/mydoc2.doc) replace 




 
