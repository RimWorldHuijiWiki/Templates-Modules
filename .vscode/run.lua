local GenText = require("Modules/GenText")

print("Test lua.")

print(GenText.toStringByStyle(15.3545, "Integer"))
print(GenText.toStringByStyle(15.2453, "FloatOne"))
print(GenText.toStringByStyle(15.5412, "FloatTwo"))
print(GenText.toStringByStyle(15.3654, "PercentZero"))
print(GenText.toStringByStyle(15.36644, "PercentOne"))
print(GenText.toStringByStyle(15.33644, "PercentTwo"))
print(GenText.toStringByStyle(15.33669, "Temperature"))
print(GenText.toStringByStyle(15.123546, "TemperatureOffset"))
print(GenText.toStringByStyle(36522, "WorkAmount"))
print(GenText.toStringByStyle("sdfsdfsd", "WorkAmount"))