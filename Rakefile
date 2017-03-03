Rake::TaskManager.record_task_metadata = true

namespace 'task' do
  desc 'List available task'
  task :list do
    app = Rake.application
    app.tasks.each do |task|
      puts "%-20s  # %s" % [task.name, task.full_comment]
    end
  end
end

desc 'List available tasks'
task :default do
  Rake.application['task:list'].invoke
end
