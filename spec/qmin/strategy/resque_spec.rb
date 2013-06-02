require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe Qmin::Strategy::Resque do
  subject{ Qmin::Strategy::Resque.new }

  it 'creates background_call_job' do
    ::Resque.expects(:enqueue_to).with('qmin_resque_background_call_job_test_class_action', Qmin::Resque::BackgroundCallJob, 'TestClass', :action, 555)
    subject.background_call(TestClass.new(555), :action)
  end

  it 'enqueues job' do
    ::Resque.expects(:enqueue).with(TestClass, 1, 2, 3)
    subject.enqueue(TestClass, 1, 2, 3)
  end

  it 'pushes to specified queue' do
    subject.enqueue(TestJob, 1, 2, 3)
    ::Resque.queue['test_job'].should eql [{:class=>TestJob, :args=>[1, 2, 3]}]
  end

end