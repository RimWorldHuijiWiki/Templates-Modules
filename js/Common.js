/* 这里的任何JavaScript将为所有用户在每次页面载入时加载。 */

// ECharts
$(document).ready(function() {
    var allCharts = document.getElementsByClassName("echarts");
    if (allCharts.length > 0) {
        $.getScript("https://cdn.bootcss.com/echarts/3.5.3/echarts.min.js", function() {
            for (var i = 0; i < allCharts.length; i++) {
                try {
                    var curOption = JSON.parse(allCharts[i].innerHTML);
                    if (curOption.formatterStyle === "Curve") {
                        var tooltipTitle = curOption.tooltip.formatter;
                        curOption.tooltip.formatter = function(params) {
                            var serie = params[0]
                            if (serie === null) {
                                return tooltipTitle;
                            }
                            var data = serie.data || [0, 0];
                            return tooltipTitle + "<br/>" + data[0] + " => " + data[1];
                        }
                    } else if (curOption.formatterStyle === "CurvePercent") {
                        var tooltipTitle = curOption.tooltip.formatter;
                        curOption.tooltip.formatter = function(params) {
                            var serie = params[0]
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
                    var curChart = echarts.init(allCharts[i]);
                    var curLoading = allCharts[i].nextElementSibling
                    if (curLoading !== null && curLoading.className === "echarts-loading") {
                        curLoading.className += " echarts-loading-hide";
                    }
                    curChart.setOption(curOption);
                } catch (e) {
                    allCharts[i].innerHTML = "<span style=\"color:red;font-size:18px;\">Echarts 配置项错误：" + e + "</span>";
                    var curLoading = allCharts[i].nextElementSibling
                    if (curLoading !== null && curLoading.className === "echarts-loading") {
                        curLoading.className += " echarts-loading-hide";
                    }
                }
            }
        })
    }
});
