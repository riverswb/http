require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*.rb'].exclude('test/server_test.rb')
end
task default: :test
