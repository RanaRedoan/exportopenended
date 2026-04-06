# 📊 exportopenended: Export Open-Ended Survey Responses to Excel

`exportopenended` is a Stata program that exports **open-ended survey responses** to an Excel file in **long format**.  
It is especially useful for preparing survey text data for translation, coding, or further qualitative analysis.

---

## 🚀 Installation

You can install the command directly from GitHub:

```stata
net install exportopenended, from("https://raw.githubusercontent.com/RanaRedoan/exportopenended/main") replace
```
---
## 📖 Syntax
```stata
exportopenended using filename.xlsx [, replace id(varname) includeexcluded]
```
### 📌 Options
`replace` → Overwrite the Excel file if it already exists.

`id(varname)` → Specify an alternative ID variable (default is key).

`includeexcluded` → Include metadata-like string variables that are skipped by default.

## 📊 Description
`exportopenended` exports open-ended text responses from your dataset into an Excel file in long format.
It exports only values that contain at least one alphabetic character.
String values that are only numbers, spaces, dots, slashes, or other punctuation are skipped.
By default, it skips common metadata-style string variables such as `key`, `id`, `uid`, `date`, `start`, `end`, `submissiondate`, `instanceid`, and `deviceid`.
Use `includeexcluded` if you want those fields scanned as well.

This is useful for SurveyCTO, Kobo, or ODK exports where some open-ended fields are stored as strings but contain only numeric codes such as `"123"` or `"1 2 3"`.

The output Excel file contains four columns:

`ID` `variable` (default `key`)
Original variable name
Text response (data)
Empty column for translations (translated)
This format makes it easy to handle open-ended responses for coding, translation, or analysis in Excel or other software.

During export, the command shows a clean progress display for each exported variable and then prints a final summary with the output file, number of exported variables, and number of exported responses.

## 💻 Examples
Export using the default ID variable (key) and replace existing file:
```stata
exportopenended using "responses.xlsx", replace
```
Export using a custom ID variable (patient_id) and replace existing file:
```stata
exportopenended using "output.xlsx", id(patient_id) replace
```
Export while including metadata/date-like string variables:
```stata
exportopenended using "output.xlsx", includeexcluded replace
```

## 🤝 Contribution
Pull requests and suggestions are welcome!
If you find issues or have feature requests, please open an Issue in the repository.

👨‍💻 Author
Md. Redoan Hossain Bhuiyan
📧 redoanhossain630@gmail.com
