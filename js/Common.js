/* 这里的任何JavaScript将为所有用户在每次页面载入时加载。 */

// hexagon clip-path for biome
$(document).ready(function() {
    $("body").prepend('<svg height="0" width="0"><defs><clipPath id="clip-path-hexagon-x64"><polygon points="0 32, 16 5, 48 5, 64 32, 48 59, 16 59" /></clipPath></defs></svg>');
    $("body").prepend('<svg height="0" width="0"><defs><clipPath id="clip-path-hexagon-x128"><polygon points="0 64, 32 9, 96 9, 128 64, 96 119, 32 119" /></clipPath></defs></svg>');
    $(".rw-hexagon-x64").css("clip-path", "url(#clip-path-hexagon-x64)")
    $(".rw-hexagon-x128").css("clip-path", "url(#clip-path-hexagon-x128)")
});

// ECharts
$(document).ready(function() {
    var allChartsContainer = document.getElementsByClassName("echarts");
    if (allChartsContainer.length > 0) {
        $.getScript("https://cdn.bootcss.com/echarts/3.5.3/echarts.min.js", function() {
            var allCharts = new Array();
            for (var i = 0; i < allChartsContainer.length; i++) {
                try {
                    var curOption = JSON.parse(allChartsContainer[i].innerHTML);
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
                    var curChart = echarts.init(allChartsContainer[i]);
                    var curLoading = allChartsContainer[i].nextElementSibling;
                    if (curLoading !== null && curLoading.className === "echarts-loading") {
                        curLoading.className += " echarts-loading-hide";
                    }
                    curChart.setOption(curOption);
                    allCharts.push(curChart);
                } catch (e) {
                    allChartsContainer[i].innerHTML = "<span style=\"color:red;font-size:18px;\">Echarts 配置项错误：" + e + "</span>";
                    var curLoading = allChartsContainer[i].nextElementSibling;
                    if (curLoading !== null && curLoading.className === "echarts-loading") {
                        curLoading.className += " echarts-loading-hide";
                    }
                }
            }
            window.addEventListener("resize", function(event) {
                for (var i = 0; i < allCharts.length; i++) {
                    allCharts[i].resize();
                }
            })
        })
    }
});
