{smcl}
{* *! version 1.1 05apr2026}{...}
{hline}
help for {hi:exportopenended}
{hline}

{title:Title}

{p 4 4 2}
{bf:exportopenended} - Export open-ended survey responses to Excel in long format

{title:Syntax}

{p 4 4 2}
{cmd:exportopenended} {cmd:using} {it:filename.xlsx} [{cmd:,} {opt replace} {opt id(varname)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt replace}}overwrite existing Excel file{p_end}
{synopt:{opt id(varname)}}specify ID variable (default is {cmd:key}){p_end}
{synoptline}

{title:Description}

{p 4 4 2}
{cmd:exportopenended} exports all open-ended text responses from your dataset to an Excel file in long format.
Only responses containing at least one alphabetic character are exported.
String values made only of digits, spaces, dots, slashes, or other punctuation are skipped.
The output contains four columns:

{p 8 8 2}
1. ID variable (default {cmd:key}){p_end}
{p 8 8 2}
2. Original variable name{p_end}
{p 8 8 2}
3. Text response ({cmd:data}){p_end}
{p 8 8 2}
4. Empty column for translations ({cmd:translated}){p_end}

{title:Options}

{phang}
{opt replace} overwrites the Excel file if it exists.

{phang}
{opt id(varname)} specifies an alternative ID variable (default is {cmd:key}).

{title:Output}

{p 4 4 2}
During export, {cmd:exportopenended} prints a concise progress message for each variable that contributes text responses.
When the export finishes, it reports the output file, the number of variables exported, and the number of responses exported.

{title:Examples}

{p 4 4 2}
Export with default ID variable "key":

{p 8 8 2}
{cmd: exportopenended using "responses.xlsx", replace}

{p 4 4 2}
Export with custom ID variable:

{p 8 8 2}
{cmd: exportopenended using "output.xlsx", id(patient_id) replace}

{title:Author}

{p 4 4 2}
Md. Redoan Hossain Bhuiyan, redoanhossain630@gmail.com{p_end}
