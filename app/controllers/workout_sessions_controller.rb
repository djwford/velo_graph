class WorkoutSessionsController < ApplicationController

  def new
    @workoutSession = WorkoutSession.new
    # Resque.enqueue(SpeedListener)
    puts 'new action triggered'
    # Speedo.new
  end

  def create
    @workoutSession = WorkoutSession.new(params[:id])
  end


end
