

$(document).ready(function(){
  // Pusher.log = function(message) {
    // if (window.console && window.console.log) {
      // window.console.log(message);
    // }
  // };

  // var pusher = new Pusher('b225a88077e75c63ab93', {
    // encrypted: true
  // });
  // var channel = pusher.subscribe('speed');
  // channel.bind('new_speed', function(data) {
   // console.log(data);
  // });

  if (!!window.EventSource) {
    //empty the local storage
    localStorage.clear();
    var source = new EventSource('/messages');
    console.log("subscribed to event source");
    source.addEventListener('message', function(e) {
      if($("#start_button").data("active") == "true")
      {
        logData(e.data);
      }
      else
      {
        console.log("Received but not logged: " + e.data);
      }
    }, false);
  } else {
    alert("Failed to connect to /messages");
  }

  //initialize the graph
  startHighCharts();

  $("#start_button").on("click", function(){
    $("#start_button").data("active", "true");
  });

  $("#pause_button").on("click", function(){
    $("#start_button").data("active", "false");
  });

  function logData(data)
  {
    // add to localstorage
    localStorage["speeds"] = localStorage["speeds"] + "," + data;
    // graph it
    var chart = $("#speed_graph").highcharts();
    chart.series[0].addPoint(parseInt(data, 10), true, false);
  }

  function startHighCharts()
  {
    $('#speed_graph').highcharts({
      chart: {
          type: 'line'
      },
      title: {
          text: 'Speed'
      },
      xAxis: {
          type: 'datetime'
      },
      yAxis: {
          title: {
              text: 'Fruit eaten'
          }
      },
      plotOptions: {
        series: {
          pointInterval: 2000
        }
      },

      series: [{
        data: [0]
      }]
    });
  }


});
