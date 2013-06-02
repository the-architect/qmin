require File.expand_path '../spec_helper', File.dirname(__FILE__)

describe Qmin do

  it 'loads strategies' do
    defined?(Qmin::Strategy::Inline).should eql('constant')
    defined?(Qmin::Strategy::Noop).should eql('constant')
    defined?(Qmin::Strategy::Resque).should eql('constant')
  end

  describe 'initialize' do
    it 'raises error if no strategy defined' do
      Qmin::Qmin.default_strategy = nil

      -> {
        Qmin::Qmin.new
      }.should raise_error(Qmin::MustDefineStrategyError)
    end

    it 'raises error for current if no strategy defined' do
      Qmin::Qmin.default_strategy = nil
      Qmin::Qmin.class_variable_set(:@@current, nil)

      -> {
        Qmin::Qmin.current
      }.should raise_error(Qmin::MustDefineStrategyError)
    end
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
      Qmin::Qmin.new(Qmin::Strategy::Inline)

      TestJob.expects(:perform).with(1,2,3)
      Qmin::Qmin.enqueue TestJob, 1,2,3
    end
  end

end