class MessagesController < ApplicationController
  include ActionController::Live


  def initialize
    @speed = 0
  end

  def serve
    # listen
    x = Thread.new do 
      x["speed"] = 0
      puts "SpeedListener is running!"
      $redis.subscribe("speed") do |event|
        puts 'block running'
        event.message do |channel, body|
          puts "#{body}"
          x["speed"] = body   
        end
      end
      ActiveRecord::Base.connection.close
      puts 'closed'
    end

    puts 'serving messages'
    response.headers['Content-Type'] = 'text/event-stream'
      sse = SSE.new(response.stream)
      begin
        loop do 
          # puts "#{listener.speed}"
          # sse.write("data: #{@speed}") 
          puts "speed in listener: #{x[:speed]}"
          sse.write("data: #{x[:speed]}") 
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




