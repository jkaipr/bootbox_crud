require 'bundler'
begin
  Bundler.setup
  Bundler::GemHelper.install_tasks
rescue
  raise 'You need to install the bundle first.'
end

require 'rake/testtask'
require 'fileutils'

desc 'Default: run generator and javascript tests'
task default: [:test, :test_javascript]

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = false
end

task :test_javascript do
  exec 'cd test/dummy && bundle exec rake spec:javascript'
end

task :clean_tmp do
  FileUtils.rm_rf('test/tmp')
end

Rake::Task['test'].enhance do
  Rake::Task['clean_tmp'].invoke
end
