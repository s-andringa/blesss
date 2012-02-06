/*!
 * #Blesss updater
 *
 * Listens for new blessings over a WebSocket and
 * updates list.
 */
$(function(){
  var ws = new WebSocket("ws://" + window.location.host + "/blessings");
  ws.onmessage = function (evt) {
    var blessing = $.parseJSON(evt.data);
    var li = $("<li>").text(blessing.username + " ").append($("<span>", {"class": "latest-at"}).text(blessing.time));
    $("#last-blessed ul").prepend(li);
    $("#last-blessed ul li:last").remove();
  };
  ws.onclose = function (evt) {
    console.log("WS connection closed")
  }
});