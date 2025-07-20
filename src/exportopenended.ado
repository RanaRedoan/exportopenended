*! exportopenended v1.0 - Export open-ended responses to Excel in long format
*! Syntax: exportopenended using "filename.xlsx" [, replace id(varname)]

program define exportopenended
    version 16
    syntax using/, [REPLace ID(varname)]
    
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
    
    // Identify all string variables (excluding ID variable)
    quietly ds `id', not
    local all_vars `r(varlist)'
    local text_vars ""
    
    foreach var of local all_vars {
        capture confirm string variable `var'
        if !_rc local text_vars `text_vars' `var'
    }
    
    // Check if we found any text variables
    if "`text_vars'" == "" {
        display as error "No string variables found to export"
        exit 198
    }
    
    display as text "Processing open-ended variables: " as result "`text_vars'"
    
    // Reshape using a loop
    preserve
    tempfile long_data
    save `long_data', emptyok
    
    foreach var of local text_vars {
        use `long_data', clear
        keep `id' `var'
        rename `var' data
        gen variable = "`var'"  // Preserve original name
        gen translated = ""
        drop if missing(data)
        append using `long_data'
        save `long_data', replace
    }
    
    // Final cleanup and export
    use `long_data', clear
    drop if data == ""
    keep `id' variable data translated
    order `id' variable data translated
    
    // Export to Excel
    export excel `using', firstrow(variables) `replace'
    
    display as text "Open-ended responses exported to: " as result "`using'"
    restore
end