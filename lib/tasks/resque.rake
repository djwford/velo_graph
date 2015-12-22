require 'resque/tasks'

task 'resque:setup' => :environment

# to start me: 
# rake resque:work QUEUE="*"