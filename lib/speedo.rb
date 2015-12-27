require 'pi_piper'
include PiPiper
require 'redis'


class Speedo
  attr_accessor :archive

  def initialize()
    @redis = Redis.new(:host => 'localhost', :port => 6379)
    @archive = Time.now
    listen
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
  # Thread.new do
    puts 'listening'
    PiPiper.watch :pin => 18, :pull => :up, :direction => :in do |pin|
      if(pin.value == 0) 
          puts 'pin 0'
          speed = calculate_speed(Time.now)
          @archive = Time.now
          @redis.publish("speed", speed)
      end
    end
    PiPiper.wait
  # end
end

Speedo.new

