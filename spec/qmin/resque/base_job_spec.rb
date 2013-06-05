require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe Qmin::Resque::BaseJob do

  it 'performs test job' do
    Qmin::Qmin.new(Qmin::Strategy::Resque)
    TestJob.perform(10).should eql 10
  end

  it 'demands find method on model class' do
    Qmin::Qmin.new(Qmin::Strategy::Resque)
    lambda {
      Class.new(Qmin::Resque::BaseJob) do
        model Class
      end
    }.should raise_error(Qmin::Resque::BaseJob::MustRespondToFindMethodError)
  end

  it 'demands implementation of perform method' do
    instance = Class.new(Qmin::Resque::BaseJob).new(TestClass, :action, 123)
    lambda {
      instance.perform
    }.should raise_error(Qmin::Resque::BaseJob::ImplementationMissing)

  end

  it 'supplies instance' do
    TestJob.new(10).instance.should be_a_kind_of(TestClass)
  end

end