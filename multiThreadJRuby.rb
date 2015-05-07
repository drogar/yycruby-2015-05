#!/usr/bin/env ruby
# Code courtesy of Philip Yousef - http://www.restlessprogrammer.com/2013/02/multi-threading-in-jruby.html
# used to call java code
require 'java'

# 'java_import' is used to import java classes
java_import 'java.util.concurrent.Callable'
java_import 'java.util.concurrent.FutureTask'
java_import 'java.util.concurrent.LinkedBlockingQueue'
java_import 'java.util.concurrent.ThreadPoolExecutor'
java_import 'java.util.concurrent.TimeUnit'

# Implement a callable class
class CountMillion
  include Callable
  def call
    count = 0
    1_000_000.times { count += 1 }
  end
end

num_iterations = ARGV[1].to_i
num_threads = ARGV[0].to_i
# Create a thread pool
executor = ThreadPoolExecutor.new(num_threads, # core_pool_treads
                                  num_threads, # max_pool_threads
                                  60, # keep_alive_time
                                  TimeUnit::SECONDS,
                                  LinkedBlockingQueue.new)

total_time = 0.0

num_iterations.times do |i|
  tasks = []

  t_0 = Time.now
  num_threads.times do
    task = FutureTask.new(CountMillion.new)
    executor.execute(task)
    tasks << task
  end

  # Wait for all threads to complete
  tasks.each(&:get)
  t_1 = Time.now

  time_ms = (t_1 - t_0) * 1000.0
  puts "TEST #{i}: Time elapsed = #{time_ms}ms"
  total_time +=  time_ms
end
executor.shutdown

puts "Average completion time: #{total_time / num_iterations}"
