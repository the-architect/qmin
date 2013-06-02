require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec/autorun'

# mock Resque behavior
class Resque
  def self.enqueue_to(queue_name, worker, *args)
    queue[queue_name].push({ :class => worker, :args => args })
  end

  def self.enqueue(worker_class, *args)
    queue[queue_for_class(worker_class)].push({ :class => worker_class, :args => args })
  end

  def self.queue_for_class(klass)
    klass.instance_variable_get(:@queue) || (klass.respond_to?(:queue) and klass.queue)
  end

  def self.queue
    @@queue ||= Hash.new{|h,k| h[k] = Array.new }
  end

  def self.reset_queue!
    @@queue = Hash.new{|h,k| h[k] = Array.new }
  end
end

require File.expand_path '../lib/qmin', File.dirname(__FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
  config.order = 'random'

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.filter_run_excluding :wip => true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    Resque.reset_queue!
    Qmin::Qmin.new(Qmin::Strategy::Inline)
  end

  config.after(:each) do
    Qmin::Qmin.new(Qmin::Strategy::Inline)
  end
end

class WorkerClass
  def initialize(*args)
  end

  def self.perform(*args)
    new(*args).perform
  end

  def perform

  end
end

class TestClass
  def action
    @id
  end

  def self.name
    'TestClass'
  end

  def self.find(id)
    new(id)
  end

  def initialize(id = 123)
    @id = id
  end
  attr_reader :id
end

class BackgroundTestClass < TestClass
  def self.name
    'BackgroundTestClass'
  end

  background_method :action
end

class TestJob < Qmin::Resque::BaseJob
  model TestClass

  def perform
    instance.id
  end
end