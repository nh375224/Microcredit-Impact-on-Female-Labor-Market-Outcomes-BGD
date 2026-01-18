**file directory**
use "C:\Users\nh375224\Desktop\Applied Econometrics\Papers\NAZIA.dta"

**generating gender variables**
gen male = 0
gen female = 0

replace male = 1 if gender =="M"
replace female = 1 if gender == "F"

**generating sample varaible**                                                                                                                                                                                        
gen sample = (male == 1| female == 1)

**Collapsing Data by Gender and Plotting**
preserve
collapse (mean) lfpr_smooth ,by (gender year)
twoway (line lfpr_smooth year if gender== "M") (line lfpr_smooth year if gender == "F")

restore

gen Di=1 if year>2010
replace Di=0 if Di==.

gen treated=1 if gender == "F"
replace treated=0 if treated==.


*Trend line*
preserve
keep if year >= 2000 & year <= 2022
collapse (mean) lfpr_smooth, by(year gender)
twoway (line lfpr_smooth year if gender == "M", lcolor(red) lpattern(dash)legend(label(1 "Male")))(line lfpr_smooth year if gender == "F", lcolor(blue) lpattern(solid)legend(label(2 "Female"))), ytitle("LFPR (smoothed)") xtitle("Year")title("Labor Force Participation by Gender (2010–2022)")legend(position(6) ring(0))xline(2010, lpattern(dash) lcolor(black))

restore


keep if year >= 2000
**generating post-policy period variable**
gen post_2010 = (year >= 2010)
gen did = post_2010 * treated
**generating interaction term for DiD**
gen interaction=(treated*Di)
reg lfpr_smooth treated##post_2010 i.year		
margins treated#post_2010


*trend line after policy intervention*

preserve
keep if year >= 2016 & year <= 2022
collapse (mean) lfpr_smooth, by(year gender)
twoway (line lfpr_smooth year if gender == "M", lcolor(red) lpattern(dash)legend(label(1 "Male")))(line lfpr_smooth year if gender == "F", lcolor(blue) lpattern(solid)legend(label(2 "Female"))), ytitle("LFPR (smoothed)") xtitle("Year")title("Labor Force Participation by Gender (2010–2022)")legend(position(6) ring(0))xline(2010, lpattern(dash) lcolor(black))

restore
