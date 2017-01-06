<!doctype html>
<html>

<head>
    <title>Line Chart - Cubic interpolation mode</title>
    <script src="${pageContext.request.contextPath}/resources/js/Chart.bundle.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/utils.js"></script>
    <style>
    canvas{
        -moz-user-select: none;
        -webkit-user-select: none;
        -ms-user-select: none;
    }
    </style>
</head>

<body>
    <div style="width:75%;">
        <canvas id="canvas"></canvas>
    </div>
    <br>
    <br>
    <button id="randomizeData">Randomize Data</button>
    <script>

        var randomScalingFactor = function() {
            return Math.round(Math.random() * 100);
        };

        var datapoints = [0, 20, 20, 60, 60, 120, NaN, 180, 120, 125, 105, 110, 170];
		var config = {
            type: 'line',
            data: {
                labels: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
                datasets: [{
                    label: "Cubic interpolation (monotone)",
                    data: datapoints,
                    borderColor: window.chartColors.red,
					backgroundColor: 'rgba(0, 0, 0, 0)',
                    fill: false,
					cubicInterpolationMode: 'monotone'
                }, {
                    label: "Cubic interpolation (default)",
                    data: datapoints,
                    borderColor: window.chartColors.blue,
					backgroundColor: 'rgba(0, 0, 0, 0)',
                    fill: false,
                }, {
                    label: "Linear interpolation",
                    data: datapoints,
                    borderColor: window.chartColors.green,
					backgroundColor: 'rgba(0, 0, 0, 0)',
                    fill: false,
					lineTension: 0
                }]
            },
            options: {
                responsive: true,
                title:{
                    display:true,
                    text:'Chart.js Line Chart - Cubic interpolation mode'
                },
                tooltips: {
                    mode: 'index'
                },
                scales: {
                    xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true
                        }
                    }],
                    yAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: 'Value'
                        },
                        ticks: {
                            suggestedMin: -10,
                            suggestedMax: 200,
                        }
                    }]
                }
            }
        };

        window.onload = function() {
            var ctx = document.getElementById("canvas").getContext("2d");
            window.myLine = new Chart(ctx, config);
        };

        document.getElementById('randomizeData').addEventListener('click', function() {
			for (var i = 0, len = datapoints.length; i < len; ++i) {
				datapoints[i] = Math.random() < 0.05 ? NaN : randomScalingFactor();
			}
            window.myLine.update();
        });

    </script>
</body>

</html>
