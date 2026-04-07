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
        str20 q_text
    "k1" "uid-a" "01 Apr 2026 10:30" "08 Apr 2026" "hello"
    "k2" "uid-b" "02 Apr 2026 08:00" "09 Apr 2026" "world"
    end

    log using `"`log_path'"', text replace
    exportopenended using `"`xlsx_path'"', includeexcluded replace

    import excel using `"`xlsx_path'"', clear firstrow

    assert _N == 8
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

    count if data == "uid-a"
    assert r(N) == 1

    count if data == "01 Apr 2026 10:30"
    assert r(N) == 1

    count if data == "08 Apr 2026"
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
