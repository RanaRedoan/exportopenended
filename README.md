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
exportopenended using filename.xlsx [, replace id(varname)]
```
### 📌 Options
`replace` → Overwrite the Excel file if it already exists.

`id(varname)` → Specify an alternative ID variable (default is key).

## 📊 Description
`exportopenended` exports all open-ended text responses from your dataset into an Excel file in long format.
The output Excel file contains four columns:

`ID` `variable` (default `key`)
Original variable name
Text response (data)
Empty column for translations (translated)
This format makes it easy to handle open-ended responses for coding, translation, or analysis in Excel or other software.

## 💻 Examples
Export using the default ID variable (key) and replace existing file:
```stata
exportopenended using "responses.xlsx", replace
```
Export using a custom ID variable (patient_id) and replace existing file:
```stata
exportopenended using "output.xlsx", id(patient_id) replace
```

## 🤝 Contribution
Pull requests and suggestions are welcome!
If you find issues or have feature requests, please open an Issue in the repository.

👨‍💻 Author
Md. Redoan Hossain Bhuiyan
📧 redoanhossain630@gmail.com
