class SpeedController < ApplicationController

  def index
    @speed_record = SpeedRecord.all
  end

  def workout

  end
end
