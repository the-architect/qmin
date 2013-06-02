require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe Qmin::Strategy::Inline do
  subject{ Qmin::Strategy::Inline.new }

  it 'enqueues job' do
    WorkerClass.expects(:perform).with(1,2,3)
    subject.enqueue(WorkerClass, 1,2,3)
  end

  it 'calls background call method' do
    subject.background_call(BackgroundTestClass.new, :action).should eql 123
  end
end