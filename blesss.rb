require "sinatra/base"

class Blesss < Sinatra::Base
  set :haml, :format => :html5
  set :views, settings.root + "/app/views"
  set :debug, development?

  helpers AssetHelpers

  get "/" do
    @top_blessed = Person.top_blessed(5)
    @last_blessed = Person.last_blessed(5)
    haml :index
  end

  get "/ws/blessings" do
    if request.websocket?
      sub = EM::Hiredis.connect
      request.websocket!(
        on_start: ->(ws){
          sub.subscribe("blessings")
          sub.on(:message) do |c, message|
            ws.send_message(message)
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
end