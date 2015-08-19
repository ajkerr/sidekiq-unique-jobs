begin
  require 'pry'
rescue LoadError
  puts 'Pry unavailable'
end

require 'rspec'

require 'celluloid/test'
require 'sidekiq'
require 'sidekiq/util'
require 'sidekiq-unique-jobs'
Sidekiq.logger.level = Logger::ERROR
require 'sidekiq_unique_jobs/testing'

require 'rspec-sidekiq'

Sidekiq::Testing.disable!

require 'sidekiq/redis_connection'
redis_url = ENV['REDIS_URL'] || 'redis://localhost/15'
REDIS = Sidekiq::RedisConnection.create(url: redis_url, namespace: 'sidekiq-unique-jobs-testing')

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }
RSpec.configure do |_config|
  # config.treat_symbols_as_metadata_keys_with_true_values = true
end

RSpec::Sidekiq.configure do |config|
  # Clears all job queues before each example
  config.clear_all_enqueued_jobs = true

  # Whether to use terminal colours when outputting messages
  config.enable_terminal_colours = true

  # Warn when jobs are not enqueued to Redis but to a job array
  config.warn_when_jobs_not_processed_by_sidekiq = false
end
