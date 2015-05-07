#!/usr/bin/env ruby

# Code courtesy of Philip Yousef - http://www.restlessprogrammer.com/2013/02/multi-threading-in-jruby.html
# modified to take parameters.
num_iterations = ARGV[1].to_i
num_threads = ARGV[0].to_i

# Try counting to 1 million on 4 separate threads 20 times
total_time = 0.0
num_iterations.times do |iter|
  threads = []
  t_0 = Time.now
  (1..num_threads).each do |i|
    threads << Thread.new(i) do
      count = 0
      1_000_000.times { count += 1 }
    end
  end

  # Wait for all threads to complete
  threads.each(&:join)
  t_1 = Time.now

  time_ms = (t_1 - t_0) * 1000
  puts "TEST #{iter}: Time elapsed = #{time_ms}ms"
  total_time +=  time_ms
end

puts "Average completion time: #{total_time / num_iterations}"
