*! exportopenended v1.2 - Export open-ended responses to Excel in long format
*! Syntax: exportopenended using "filename.xlsx" [, replace id(varname) includeexcluded]

program define exportopenended
    version 16
    syntax using/, [REPLace ID(varname) INCLUDEEXCLUDED]

    // Set default ID variable to 'key' if not specified
    if "`id'" == "" {
        local id "key"
        capture confirm variable `id'
        if _rc {
            display as error "Default ID variable 'key' not found in dataset"
            exit 111
        }
    }
    
    // Verify the ID variable exists
    capture confirm variable `id'
    if _rc {
        display as error "ID variable `id' not found in dataset"
        exit 111
    }

    // Identify all string variables, skipping common metadata-like names by default
    local total_obs = _N
    local same_length_threshold = max(3, ceil(`total_obs' * 0.3))
    quietly ds `id', not
    local all_vars `r(varlist)'
    local text_vars ""
    local excluded_name_pattern "(^|_)(key|id|uid|uuid|instanceid|instance_id|submissiondate|submission_date|date|datetime|date_time|start|starttime|start_time|end|endtime|end_time|deviceid|device_id)($|_)"

    foreach var of local all_vars {
        local lower_var = lower("`var'")
        capture confirm string variable `var'
        if _rc {
            continue
        }

        if "`includeexcluded'" == "" {
            if regexm("`lower_var'", "`excluded_name_pattern'") {
                continue
            }
        }

        if strpos("`lower_var'", "name") {
            continue
        }

        local text_vars `text_vars' `var'
    }

    // Check if we found any text variables
    if "`text_vars'" == "" {
        display as error "No string variables found to evaluate for export"
        exit 198
    }

    preserve
    tempfile source_data long_data
    quietly save `source_data'

    local idtype : type `id'
    local id_is_string 0
    capture confirm string variable `id'
    if !_rc {
        local id_is_string 1
    }
    local exported_vars 0
    local exported_rows 0

    quietly clear
    quietly set obs 0

    if `id_is_string' {
        quietly gen `idtype' `id' = ""
    }
    else {
        quietly gen `idtype' `id' = .
    }

    quietly gen str32 variable = ""
    quietly gen strL data = ""
    quietly gen strL translated = ""
    quietly save `long_data', replace emptyok

    foreach var of local text_vars {
        tempvar data_length length_count
        quietly use `source_data', clear
        quietly keep `id' `var'
        quietly replace `var' = ustrtrim(`var')

        quietly gen int `data_length' = ustrlen(`var') if `var' != ""
        quietly bysort `data_length': gen long `length_count' = _N if `var' != ""
        quietly summarize `length_count', meanonly

        if r(N) > 0 & r(max) >= `same_length_threshold' {
            continue
        }

        quietly rename `var' data
        quietly keep if ustrregexm(data, "\p{L}")
        quietly count

        if r(N) == 0 {
            continue
        }

        local rows_this_var = r(N)
        display as text "Exporting `var'..."

        quietly gen str32 variable = "`var'"
        quietly gen strL translated = ""
        quietly order `id' variable data translated
        quietly append using `long_data', nolabel
        quietly save `long_data', replace

        local ++exported_vars
        local exported_rows = `exported_rows' + `rows_this_var'
        display as text "`var' exported."
    }

    if `exported_rows' == 0 {
        restore
        display as error "No open-ended responses containing letters were found to export"
        exit 198
    }

    quietly use `long_data', clear
    quietly order `id' variable data translated

    // Export to Excel
    quietly export excel `"`using'"', firstrow(variables) `replace'

    display as text "Export complete."
    display as text `"File: `using'"'
    display as text `"Variables exported: `exported_vars'"'
    display as text `"Responses exported: `exported_rows'"'
    restore
end
