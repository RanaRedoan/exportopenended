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
        str20 sub_date ///
        str20 name_respondent ///
        str12 enum_code ///
        str20 story_var ///
        str20 q_text
    "k1" "u-a1"    "Apr 6 9am"  "Apr 6"    "Rahim" "ENUM10056" "alpha"   "hello"
    "k2" "uid-b22" "7 Apr 10am" "7-Apr-26" "Karim" "ENUM10057" "planet"  "world"
    "k3" ""        ""           ""         "Suma"  "ENUM10058" "orchard" ""
    "k4" ""        ""           ""         ""      ""          ""        ""
    "k5" ""        ""           ""         ""      ""          ""        ""
    "k6" ""        ""           ""         ""      ""          ""        ""
    "k7" ""        ""           ""         ""      ""          ""        ""
    "k8" ""        ""           ""         ""      ""          ""        ""
    "k9" ""        ""           ""         ""      ""          ""        ""
    "k10" ""       ""           ""         ""      ""          ""        ""
    end

    gen str20 near_threshold = ""
    replace near_threshold = "stone" in 1
    replace near_threshold = "bread" in 2
    replace near_threshold = "sun" in 3

    log using `"`log_path'"', text replace
    exportopenended using `"`xlsx_path'"', includeexcluded replace

    import excel using `"`xlsx_path'"', clear firstrow

    assert _N == 14
    confirm variable key
    confirm variable variable
    confirm variable data
    confirm variable translated

    count if variable == "q_text"
    assert r(N) == 2

    count if variable == "UID"
    assert r(N) == 2

    count if variable == "StartTime"
    assert r(N) == 2

    count if variable == "sub_date"
    assert r(N) == 2

    count if variable == "story_var"
    assert r(N) == 3

    count if variable == "near_threshold"
    assert r(N) == 3

    count if inlist(variable, "name_respondent", "enum_code")
    assert r(N) == 0

    count if data == "u-a1"
    assert r(N) == 1

    count if data == "Apr 6 9am"
    assert r(N) == 1

    count if data == "Apr 6"
    assert r(N) == 1

    count if data == "stone"
    assert r(N) == 1

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
