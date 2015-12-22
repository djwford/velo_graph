class SpeedListener
  def initialize
    @speed = 0
    listen
    puts "SpeedListener initialized: #{@speed}"
  end

  def listen
    Thread.new do 
      puts "SpeedListener is running!"
      $redis.subscribe("speed") do |event|
        puts 'block running'
        event.message do |channel, body|
          puts "#{body}"
          @speed = body        
        end
      end
      ActiveRecord::Base.connection.close
      puts 'closed'
    end

  end

end

# bundle exec rake environment resque:work QUEUE=sleep