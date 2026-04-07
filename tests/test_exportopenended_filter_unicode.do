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
        id ///
        str20 q_text ///
        str20 q_numeric ///
        str20 q_punct ///
        str20 q_mixed
    1 "hello"       "123"   "."   "word"
    2 "placeholder" "1 2 3" "/"   "4 5"
    3 ""            "789"   "..." "abc/123"
    4 "   "         ""      " / " ""
    end

    gen str20 q_fixed = ""
    replace q_text = "survey" in 1
    replace q_fixed = "AA11" in 1
    replace q_fixed = "BB22" in 2

    replace q_text = ustrunescape("\u09AC\u09BE\u0982\u09B2\u09BE") in 2

    log using `"`log_path'"', text replace
    exportopenended using `"`xlsx_path'"', id(id) replace

    import excel using `"`xlsx_path'"', clear firstrow

    assert _N == 4
    confirm variable id
    confirm variable variable
    confirm variable data
    confirm variable translated

    count if variable == "q_text"
    assert r(N) == 2

    count if variable == "q_mixed"
    assert r(N) == 2

    count if inlist(variable, "q_numeric", "q_punct", "q_fixed")
    assert r(N) == 0

    count if inlist(data, "123", "1 2 3", "789", ".", "/", "...", "AA11", "BB22")
    assert r(N) == 0

    count if data == "survey"
    assert r(N) == 1

    count if data == ustrunescape("\u09AC\u09BE\u0982\u09B2\u09BE")
    assert r(N) == 1

    count if data == "word"
    assert r(N) == 1

    count if data == "abc/123"
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
