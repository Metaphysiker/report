
function barWithLabel(data, divtag){

    var chartdata = data;
    var ctx = document.getElementById(divtag);
    var data = {
        labels: Object.keys(chartdata),
        datasets: [{
            label: 'Anzahl Profile',
            data: Object.values(chartdata),
            backgroundColor: "#4082c4"
        }]
    }
    var myChart = new Chart(ctx, {
                type: 'bar',
                data: data,
                options: {
                    "hover": {
                        "animationDuration": 0
                    },
                    "animation": {
                        "duration": 1,
                        "onComplete": function() {
                            var chartInstance = this.chart,
                                ctx = chartInstance.ctx;

                            ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, Chart.defaults.global.defaultFontStyle, Chart.defaults.global.defaultFontFamily);
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'bottom';

                            this.data.datasets.forEach(function(dataset, i) {
                                var meta = chartInstance.controller.getDatasetMeta(i);
                                meta.data.forEach(function(bar, index) {
                                    var data = dataset.data[index];
                                    ctx.fillText(data, bar._model.x + 10, bar._model.y + 5);
                                });
                            });
                        }
                    },
                    legend: {
                        "display": true
                    },
                    tooltips: {
                        "enabled": true
                    },
                    scales: {
                        yAxes: [{
                            display: true,
                            gridLines: {
                                display: true
                            },
                            ticks: {
                                //max: Math.max(...data.datasets[0].data) + 10,
                                display: true,
                                beginAtZero: true
                            }
                        }],
                        xAxes: [{
                            gridLines: {
                                display: false
                            },
                            ticks: {
                                //max: Math.max(...data.datasets[0].data) + 10,
        beginAtZero: true
}
}]
}
}
});

    return myChart;
}
