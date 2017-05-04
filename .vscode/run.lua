local SimpleCurve = require("Modules/RW_AssemblyCSharp/AC_SimpleCurve")

sc = SimpleCurve:new('"(0,0)","(0.2,0.7)","(0.5, 0.86)","(0.8, 0.93)","(0.96,0.96)","(1.0,0.98)","(1.1,0.985)","(1.3,0.99)","(1.8,0.995)","(10,1)"')

for i, p in pairs(sc.points) do
    print("(" .. p.x .. "," .. p.y .. ")")
end
