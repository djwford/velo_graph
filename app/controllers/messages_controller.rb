class MessagesController < ApplicationController
  include ActionController::Live
  require 'json'

  def initialize
    @posted_speed = 0
  end

  def serve
    # listen
    x = Thread.new do 
      x["speed"] = 0
      puts "SpeedListener is running!"
      $redis.subscribe("speed") do |event|
        puts 'block running'
        event.message do |channel, body|
          puts "messages_controller picked up: #{body}"
          x["speed"] = body 
          puts "speed in thread: #{x[:speed]}"  
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
          # when th7e user stops pedaling, the speed will cease
          # to be updated. Compare the previously posted speed
          # to the current redis speed. Set to 0 if they're the same
            current_speed = x[:speed]
            if @posted_speed != current_speed
              puts "SSE writing #{current_speed}"
              sse.write(current_speed) 
              @posted_speed = current_speed
            else
              puts "current: #{current_speed}, posted: #{@posted_speed}"
              sse.write(0)
            end
            sleep 2 
        end 
      rescue IOError
        # Client Disconnected
      ensure
        sse.close
      end
    render nothing: true       
  end

end




