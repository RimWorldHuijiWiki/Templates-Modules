/* 这里的任何JavaScript将为所有用户在每次页面载入时加载。 */

// ECharts
$(document).ready(function() {
    var allCharts = document.getElementsByClassName('echarts');
    if (allCharts.length > 0) {
        $.getScript("https://cdn.bootcss.com/echarts/3.5.3/echarts.min.js", function() {
            for (var i = 0; i < allCharts.length; i++) {
                try {
                    var curOption = JSON.parse(allCharts[i].innerHTML);
                    var curChart = echarts.init(allCharts[i]);
                    curChart.setOption(curOption);
                } catch (e) {
                    allCharts[i].innerHTML = e;
                }
            }
        })
    }
});