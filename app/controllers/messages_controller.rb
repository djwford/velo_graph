class MessagesController < ApplicationController
  include ActionController::Live
  require 'json'

  def initialize
    @posted_speed = 0
  end

  def serve
    # listen
    x = Thread.new do 
      puts "SpeedListener is running!"
      $redis.subscribe("speed") do |event|
        puts 'block running'
        event.message do |channel, body|
          puts "messages_controller picked up: #{body}"
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
          # this loop posts the last speed posted to redis;
          # when the user stops pedaling, the speed will cease
          # to be updated. Compare the previously posted speed
          # to the current redis speed. Set to 0 if they're the same
            puts "SSE writing #{x[:speed]}"
            sse.write(x[:speed]) 
            
            @posted_speed = x[:speed]
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




