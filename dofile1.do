

use "C:\Users\nh375224\Desktop\Thesis\hies_mircocredit.dta"

**summerize by year**

bysort year: summarize gender age working_status

tabulate gender

tabulate age

tabulate working_status



**microcredit information**
tab frst_source_financing if year == 2004
tab frst_source_financing if year == 2010
tab frst_source_financing if year == 2016

tab scnd_source_financing if year == 2004
tab scnd_source_financing if year == 2010
tab scnd_source_financing if year == 2016

table year gender if inlist(year, 2004, 2010, 2016), c(mean used_microcredit)
table year gender if inlist(year, 2004, 2010, 2016), c(mean used_microcredit) format(%9.2f)


**district**

tabulate dist_name if year == 2004
tabulate dist_name if year == 2010
tabulate dist_name if year == 2016


**Keeping relevant observations**

preserve
keep if inlist(year, 2004, 2010, 2016) & used_microcredit == 1 & !missing(dist_name)

restore

tabulate year type_employment

tabulate year type_employment if type_employment == 2

gen self_employed_nonagri = (type_employment == 2 & s5q08a==1)
tabulate gender self_employed_nonagri, row
table year gender, c(mean self_employed_nonagri)
 


table year gender , c(mean used_microcredit)
br if used_microcredit & year==2016 & enterprise_number !=.
table year gender if enterprise_number !=. , c(mean used_microcredit)
table year gender if type_enterprise !="" , c(mean used_microcredit)
table year gender if type_enterprise !="" , c(mean used_microcredit)



tabulate gender self_employed_nonagri, row
tabulate gender self_employed_nonagri if used_microcredit==1, row
tabulate gender self_employed_nonagri if used_microcredit==0, row
tabulate gender self_employed_nonagri if age>18, row
tabulate gender self_employed_nonagri if age>18 & age<65, row
tabulate gender used_microcredit if self_employed_nonagri==1 & age>18 & age<65, row
tabulate gender used_microcredit if self_employed_nonagri==1 & age>18 & age<65
tabulate gender hhold_used_microcredit if self_employed_nonagri==1 & age>18 & age<65


keep if age >= 18 & age <= 65
gen treated = .
replace treated = 1 if gender == 2 & marital_status == 1
replace treated = 0 if gender == 1 & marital_status == 2
gen post=(year>=2010)
reg self_employed_nonagri treated##post, robust
tab treated post


codebook type_employment type_enterprise type_emplymnt
codebook s5q08a

**Trends for non-agricultural sector**
preserve
keep if year <= 2010
collapse (mean) self_employed_nonagri , by(treated year)
twoway (line self_employed_nonagri year if treated == 1, sort lpattern(solid))(line self_employed_nonagri year if treated == 0, sort lpattern(dash)), legend(label(1 "Treated: Married Women") label(2 "Control: Unmarried Men")) title("Parallel Trends: Self-Employment in Non-Ag") ytitle("Mean Self-Employed Non-Agri") xtitle("Year")
restore

**regression with year effect**
replace self_employed_nonagri = . if type_employment !=2
reg self_employed_nonagri treated##post i.year treated, robust
reg self_employed_nonagri treated##post i.year treated, vce(cluster treated)


**regression uising controls**
encode dist_name, gen(dist_id)
reg self_employed_nonagri treated##post i.age i.religion i.dist_id i.marital_status , robust 

**Men using microcredit**
gen man_used_mc = (gender == 1 & used_microcredit == 1)
tabulate year if man_used_mc == 1


tabulate year gender if used_microcredit == 1, row col
