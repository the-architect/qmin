require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe Qmin::Resque::BackgroundCallJob do
  let(:id){ 123 }

  before do
    Qmin::Qmin.default_strategy = Qmin::Strategy::Resque
  end

  it 'calls method on instance' do
    ::Qmin::Resque::BackgroundCallJob.new(TestClass, :action, id).perform.should eql id
  end

  it 'calls method on instance wrapped in background_call_job' do
    BackgroundTestClass.new(id).action
    ::Resque.queue['qmin_resque_background_call_job_background_test_class_action'][0].should eql ({:class => Qmin::Resque::BackgroundCallJob, :args => ['BackgroundTestClass', :action, 123]})
  end

  it 'delegates perform to instance' do
    Qmin::Resque::BackgroundCallJob.any_instance.expects(:perform)
    Qmin::Resque::BackgroundCallJob.perform(BackgroundTestClass, 'action', 123)
  end

end