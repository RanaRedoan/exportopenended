* Example 1: Basic usage with default ID variable "key"
use "SurveyDataset.dta", clear

// Keep only relevant variables including the ID and open-ended responses
keep key q1_open q2_comments q3_other notes

// Export to Excel in long format
exportopenended using "clinical_open_ends.xlsx", id(key) replace
