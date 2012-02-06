set :haml, :format => :html5
set :views, settings.root + "/app/views"

get "/" do
  @top_blessed = Person.top_blessed(5)
  @last_blessed = Person.last_blessed(5)
  haml :index
end

get "/blessings" do
  if request.websocket?
    sub = EM::Hiredis.connect
    request.websocket!(
      on_start: ->(ws){
        sub.subscribe "blessings"
        sub.on(:message) do |channel, message|
          ws.send_message({ username: message, time: Time.now.strftime("%d/%m, %H:%M") }.to_json)
        end
      },
      on_close: ->(ws){
        sub.close_connection
      }
    )
  else
    [406, "Websocket connection required."]
  end
end