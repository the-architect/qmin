require File.expand_path '../../spec_helper', File.dirname(__FILE__)
require File.expand_path '../../../lib/qmin', File.dirname(__FILE__)

describe 'Qmin::Reporting::Rollbar' do

  before do
    Qmin::Qmin.default_reporter = Qmin::Reporting::Rollbar
  end

  let(:error_producer){ TestClass.new(123) }

  it 'raises error with default inline strategy' do
    Rollbar.expects(:report_exception).with(kind_of(TestClass::CustomError))
    error_producer.raise_error
  end

  it 'raises no error with noop strategy' do
    Qmin::Qmin.default_strategy = Qmin::Strategy::Noop
    Rollbar.expects(:report_exception).never

    lambda{
      error_producer.raise_error
    }.should_not raise_error
  end

  describe 'resque strategy' do
    before do
      Qmin::Qmin.default_strategy = Qmin::Strategy::Resque
    end

    it 'raises no error with resque strategy when enqueueing the job' do
      lambda{
        error_producer.raise_error
      }.should_not raise_error
    end

    it 'raises error when job is performing' do
      Rollbar.expects(:report_exception).with(kind_of(TestClass::CustomError))

      Qmin::Resque::BackgroundCallJob.new(TestClass, :raise_error, error_producer.id).perform
    end
  end

end

