class MessagesController < ApplicationController
  include ActionController::Live

  def serve
    listener = SpeedListener.new
    puts 'serving messages'
    response.headers['Content-Type'] = 'text/event-stream'

      sse = SSE.new(response.stream)
      begin
        loop do 
          # puts "#{listener.speed}"
          # sse.write("data: #{listener.speed}") 
          sse.write("data: 1") 

          sleep 3           
        end 
      rescue IOError
        # Client Disconnected
      ensure
        sse.close
      end
    render nothing: true       
  end
end
