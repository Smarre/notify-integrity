# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "notify-integrity"
  gem.homepage = "http://github.com/smarre/notify-integrity"
  gem.license = "MIT"
  gem.summary = %Q{A hook that can be used to notify integrity of various things.}
  gem.description = %Q{This gem provides means to notify Integrity for example to request new build.}
  gem.email = "smar@smar.fi"
  gem.authors = ["Samu Voutilainen"]
  # dependencies defined in Gemfile
  gem.add_dependency "mysql2", ">=0"
  gem.add_dependency "capybara", ">=0"
  gem.add_dependency "capybara-mechanize", ">=0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "notify-integrity #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
