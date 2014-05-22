# run like this:
# $ FILE=/path/to/file.log ruby report.rb

require 'apache_log_parser'

requests = { 301 => [], 404 => [] }

ApacheLogParser.parse(ENV['FILE']) do |parsed|
  status = parsed[:status]
  requests[status] << parsed[:resource] if requests.keys.include? status
end

requests.each do |code, resources|
  puts code
  counts = resources.inject(Hash.new(0)) { |memo, r| memo[r] += 1; memo }
  counts.sort.each { |count| puts count.join(' - ') }
end
