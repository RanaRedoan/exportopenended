# 📘 exportopenended — Open-Ended Response Exporter for Stata

`exportopenended` is a specialized tool for extracting and organizing open-ended survey responses from Stata datasets into analysis-ready Excel format. It transforms wide-format data into a clean long structure ideal for qualitative analysis or translation workflows.

---

## 🔧 Installation

Install directly from GitHub:

```stata
net install exportopenended, from("https://raw.githubusercontent.com/RanaRedoan/exportopenended/main") replace

```example

// With custom ID
exportopenended using "Openended_Responses.xlsx", id(participant_id) replace
