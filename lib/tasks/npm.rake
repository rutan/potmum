# frozen_string_literal: true

namespace :npm do
  desc 'exec `npm run build`'
  task :build do
    puts system('npm rebuild node-sass')
    puts system('npm run build')
  end
end

Rake::Task['assets:precompile'].enhance(['npm:build'])
