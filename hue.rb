require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'open-uri'
require 'json'

if ENV['JENKINS_URL'].nil?
  raise "This script requires the JENKINS_URL env var to be defined."
end

light_index = ENV['HUE_LIGHT_INDEX'].nil? ? 0 : ENV['HUE_LIGHT_INDEX'].to_i
jenkins_url = ENV['JENKINS_URL'] + "/api/json"
pattern = ENV['JENKINS_JOB_PATTERN']
http_basic_auth = [ENV['JENKINS_HTTP_BASIC_USERNAME'], ENV['JENKINS_HTTP_BASIC_PASSWORD']] if ENV['JENKINS_HTTP_BASIC_USERNAME'] && ENV['JENKINS_HTTP_BASIC_PASSWORD']

class Job
  attr_reader :name, :color
  def initialize(hash)
    @name = hash["name"]
    @color = hash["color"]
  end

  def failed?
    color =~ /red/
  end
end

hue = Hue::Client.new
light = hue.lights[light_index]

puts "Checking for build status..."
uri = URI.parse(jenkins_url)
json = JSON.parse(open(uri, http_basic_authentication: http_basic_auth).read)

jobs = json["jobs"].map {|j| Job.new(j)}
jobs = jobs.select {|j| j.name =~ /#{pattern}/} if pattern
failed_jobs = jobs.select {|j| j.failed? }

if failed_jobs.any?
  puts "The following job(s) failed:  #{failed_jobs.map(&:name)}"
  light.set_state(:hue => 0, :sat => 255, :bri => 255)
else
  puts "builds #{jobs.map(&:name)} passing, setting green"
  light.set_state(:hue => 25500, :sat => 100, :bri => 255)
end

