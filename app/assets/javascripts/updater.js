/*!
 * #Blesss updater
 *
 * Listens for new blessings over a WebSocket and
 * updates list.
 */
$(function(){
  var blessingsChannel = new WebSocket("ws://" + window.location.host + "/ws/blessings");
  blessingsChannel.onmessage = function (evt) {
    var person = $.parseJSON(evt.data);
    var li = $("<li><a href='http://twitter.com/"+ person.username +"'>" + person.username + "</a> <span class='latest-at'>"+ person.latest_at +"</span></li>")
    $("#last-blessed ul").stop(true, true).css({top: "-35px"}).prepend(li).animate({top: "+=35px"}, function(){
      $("#last-blessed ul li:gt(4)").remove();
    })
  };

  var top5Channel = new WebSocket("ws://" + window.location.host + "/ws/top_5");
  top5Channel.onmessage = function (evt) {
    var top5 = $.parseJSON(evt.data);
    var list = $("<ul>")
    $.each(top5, function(){
      var li = $("<li><span class='cnt'>" + this.cnt + "</span> <a href='http://twitter.com/"+ this.username +"'>" + this.username + "</a></li>")
      list.append(li)
    });
    $("#top-blessed ul").replaceWith(list);
  };
});