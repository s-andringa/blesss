set :haml, :format => :html5
set :views, settings.root + "/app/views"


template :javascript_include_tag do
  "%script{ src: url, type: \"text/javascript\" }"
end

helpers do
  def javascript_include_tag(*paths)
    paths.map { |path| haml(:javascript_include_tag, locals: {url: path}) }.join("\n")
  end
end

get "/" do
  @top_blessed = Person.top_blessed(5)
  @last_blessed = Person.last_blessed(5)
  haml :index
end


get "/ws/:channel" do |channel|
  if request.websocket?
    sub = EM::Hiredis.connect
    request.websocket!(
      on_start: ->(ws){
        sub.subscribe(channel)
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