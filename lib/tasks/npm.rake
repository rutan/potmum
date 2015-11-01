namespace :npm do
  desc 'exec `npm install`'
  task :install do
    puts system('npm install')
  end

  desc 'exec `npm run build`'
  task build: ['install'] do
    puts system('npm run build')
  end
end

Rake::Task['assets:precompile'].enhance(['npm:build']) do
  # doing!
end
