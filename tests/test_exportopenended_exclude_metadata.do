clear all
set more off
capture log close _all
args log_path xlsx_path marker_path

if `"`log_path'"' == "" | `"`xlsx_path'"' == "" | `"`marker_path'"' == "" {
    exit 198
}

capture erase `"`marker_path'"'

capture noisily {
    adopath ++ "src"

    input ///
        str8 key ///
        str10 UID ///
        str20 StartTime ///
        str20 SubmissionDate ///
        str20 sub_date ///
        str20 resp_name ///
        str12 enum_code ///
        str20 story_var ///
        str20 q_text ///
        str20 comments
    "k1" "u-a1"    "Apr 6 9am"   "6 Apr"     "Apr 6"    "Rahim" "ENUM10056" "alpha"   "hello" "needs review"
    "k2" "uid-b22" "7 Apr 10am"  "07 Apr 26" "7-Apr-26" "Karim" "ENUM10057" "planet"  ""      "follow up"
    "k3" ""        ""            ""          ""         "Suma"  "ENUM10058" "orchard" "world" ""
    "k4" ""        ""            ""          ""         ""      ""          ""        ""      ""
    "k5" ""        ""            ""          ""         ""      ""          ""        ""      ""
    "k6" ""        ""            ""          ""         ""      ""          ""        ""      ""
    "k7" ""        ""            ""          ""         ""      ""          ""        ""      ""
    "k8" ""        ""            ""          ""         ""      ""          ""        ""      ""
    "k9" ""        ""            ""          ""         ""      ""          ""        ""      ""
    "k10" ""       ""            ""          ""         ""      ""          ""        ""      ""
    end

    gen str20 near_threshold = ""
    replace near_threshold = "stone" in 1
    replace near_threshold = "bread" in 2
    replace near_threshold = "sun" in 3

    log using `"`log_path'"', text replace
    exportopenended using `"`xlsx_path'"', replace

    import excel using `"`xlsx_path'"', clear firstrow

    assert _N == 10
    confirm variable key
    confirm variable variable
    confirm variable data
    confirm variable translated

    count if variable == "q_text"
    assert r(N) == 2

    count if variable == "comments"
    assert r(N) == 2

    count if variable == "story_var"
    assert r(N) == 3

    count if variable == "near_threshold"
    assert r(N) == 3

    count if inlist(variable, "UID", "StartTime", "SubmissionDate", "sub_date", "resp_name", "enum_code")
    assert r(N) == 0
 
    count if inlist(data, "Apr 6 9am", "7 Apr 10am", "6 Apr", "07 Apr 26", "Apr 6", "7-Apr-26") | ///
        inlist(data, "Rahim", "Karim", "Suma", "ENUM10056", "ENUM10057", "ENUM10058")
    assert r(N) == 0

    count if inlist(data, "stone", "bread", "sun")
    assert r(N) == 3

    count if !missing(translated)
    assert r(N) == 0

    file open marker using `"`marker_path'"', write text replace
    file write marker "ok" _n
    file close marker

    log close
}

local rc = _rc
capture log close _all
exit `rc'
