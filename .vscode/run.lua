local ColorUtility = require("Modules/RW_Template/RT_ColorUtility")

print(ColorUtility.hex2rgb("#e6af2e"))
print(ColorUtility.rgb2hex(230,175,46))
print(ColorUtility.rgbToHsl(230,175,46))
print(ColorUtility.rgbToHsl(ColorUtility.hex2rgb("#e6af2e")))

