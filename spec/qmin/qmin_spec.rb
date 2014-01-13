require File.expand_path '../spec_helper', File.dirname(__FILE__)

describe Qmin do

  it 'loads strategies' do
    defined?(Qmin::Strategy::Inline).should eql('constant')
    defined?(Qmin::Strategy::Noop).should eql('constant')
    defined?(Qmin::Strategy::Resque).should eql('constant')
  end

  describe 'background_method' do
    it 'aliases background methods'do
      subject = BackgroundTestClass.new

      subject.should respond_to(:action)
      subject.should respond_to(:action_without_qmin)
    end

    it 'calls aliased method' do
      subject = BackgroundTestClass.new

      Qmin::Qmin.expects(:background_call).with(subject, :action)
      subject.action
    end

    it 'calls original method with inline strategy' do
      subject = BackgroundTestClass.new
      subject.action
    end
  end

  describe 'enqueue' do
    it 'enqueues job' do
      TestJob.expects(:perform).with(1,2,3)
      Qmin::Qmin.enqueue TestJob, 1,2,3
    end
  end

end