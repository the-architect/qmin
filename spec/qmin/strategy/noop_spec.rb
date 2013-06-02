require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe Qmin::Strategy::Noop do
  subject{ Qmin::Strategy::Noop.new }

  it 'enqueues job' do
    WorkerClass.expects(:perform).never
    subject.enqueue(WorkerClass, 1,2,3)
  end

  it 'calls background call method' do
    BackgroundTestClass.expects(:action).never
    subject.background_call(BackgroundTestClass, :action, 123).should
  end
end