require 'pi_piper'
include PiPiper
require 'redis'
# redis = Redis.new(:host => 'localhost', :port => 6379)

class Speedo
  attr_accessor :archive

  def initialize()
    @archive = Time.now
    listen
  end

  def last_item
    @archive.pop
  end
  
  def calculate_speed(time)
    puts "time: #{time}, last_time: #{@archive}"
    elapsed = time - @archive
    puts "elapsed: #{elapsed}"
    circumference = 2 * (Math::PI) * 350
    speed = 0.001367017 / (elapsed / 3600 )
    puts speed
  end
end


def listen

  Thread.new do
    history = Speedo.new
    puts 'listening'
    PiPiper.watch :pin => 18, :pull => :up, :direction => :in do |pin|
      if(pin.value == 0) 
          history.calculate_speed(Time.now)
          history.archive = Time.now
          $redis.publish("speed", speed)
      end
    end

    PiPiper.wait
  end
end


