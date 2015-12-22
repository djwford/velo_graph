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
    var source = new EventSource('/messages');
    console.log("subscribed to event source");
  } else {
    // Result to xhr polling :(
  }

  source.addEventListener('message', function(e) {
    console.log(e.data);
  }, false);

});
