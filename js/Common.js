/* 这里的任何JavaScript将为所有用户在每次页面载入时加载。 */

// hexagon clip-path for biome
// $(document).ready(function() {
//     $("body").prepend('<svg height="0" width="0"><defs><clipPath id="clip-path-hexagon-x64"><polygon points="0 32, 16 5, 48 5, 64 32, 48 59, 16 59" /></clipPath></defs></svg>');
//     $("body").prepend('<svg height="0" width="0"><defs><clipPath id="clip-path-hexagon-x128"><polygon points="0 64, 32 9, 96 9, 128 64, 96 119, 32 119" /></clipPath></defs></svg>');
//     $(".rw-hexagon-x64").css("clip-path", "url(#clip-path-hexagon-x64)")
//     $(".rw-hexagon-x128").css("clip-path", "url(#clip-path-hexagon-x128)")
// });

// ECharts
$(document).ready(function() {
    var allOptionEles = document.getElementsByClassName("echarts");
    if (allOptionEles.length > 0) {
        mw.loader.using('ext.HuijiMiddleware.echarts', function() {
            var allCharts = new Array();
            for (var i = 0; i < allOptionEles.length; i++) {
                var curOptionEle = allOptionEles[i];
                try {
                    var curOption = JSON.parse(curOptionEle.innerHTML);
                    switch (curOption.formatterStyle) {
                        case "Curve":
                            {
                                var tooltipTitle = curOption.tooltip.formatter;
                                curOption.tooltip.formatter = function(params) {
                                    var serie = params[0];
                                    if (serie === null) {
                                        return tooltipTitle;
                                    }
                                    var data = serie.data || [0, 0];
                                    return tooltipTitle + "<br/>" + data[0] + " => " + data[1];
                                }
                            }
                            break;
                        case "CurvePercent":
                            {
                                var tooltipTitle = curOption.tooltip.formatter;
                                curOption.tooltip.formatter = function(params) {
                                    var serie = params[0];
                                    if (serie === null) {
                                        return tooltipTitle;
                                    }
                                    var data = serie.data || [0, 0];
                                    return tooltipTitle + "<br/>" + data[0] + "% => " + data[1] + "%";
                                }
                                curOption.series[0].label.normal.formatter = function(params) {
                                    var data = params.data || [0, 0];
                                    return "(" + data[0] + "%, " + data[1] + "%)";
                                }
                            }
                            break;
                        case "BiomeMap":
                            {
                                var tooltipTitle = curOption.tooltip.formatter;
                                var extraOption = curOption.extraOption;
                                var allLabels = extraOption.allLabels;
                                var rainMax = extraOption.rainMax;
                                var rainSpan = extraOption.rainSpan;
                                var tempMin = extraOption.tempMin;
                                var tempMax = extraOption.tempMax;
                                var tempSpan = extraOption.tempSpan;
                                curOption.tooltip.formatter = function(params) {
                                    // var serie = params[0];
                                    // if (serie === null) {
                                    //     return tooltipTitle;
                                    // }
                                    var data = params.data || [0, 0, 0];
                                    return allLabels[data[2] - 1] + "<br/>降雨量：" + rainSpan * data[0] + " mm，平均温度：" + (tempMin + tempSpan * data[1]) + " ℃";
                                }
                            }
                            break;
                    }
                    var curChart = echarts.init(curOptionEle);
                    var curLoadingEle = curOptionEle.nextElementSibling;
                    if (curLoadingEle !== null && curLoadingEle.className.includes("echarts-loading")) {
                        curLoadingEle.className += " echarts-loading-hide";
                    }
                    curChart.setOption(curOption);
                    allCharts.push(curChart);
                } catch (ex) {
                    curOptionEle.innerHTML = "<span style=\"color:red;font-size:18px;\">ECharts option error: " + ex + "</span>";
                    var curLoadingEle = curOptionEle.nextElementSibling;
                    if (curLoadingEle !== null && curLoadingEle.className.includes("echarts-loading")) {
                        curLoadingEle.className += " echarts-loading-hide";
                    }
                }
            }
            var allResize = function(event) {
                setTimeout(function() {
                    for (var i = 0; i < allCharts.length; i++) {
                        allCharts[i].resize();
                    }
                }, 300);
            };
            window.addEventListener("resize", allResize);
        }, function() {
            console.log("failed to load echarts module");
        });
    }
});