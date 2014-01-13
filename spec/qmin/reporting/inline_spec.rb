require_relative '../../spec_helper'
require_relative '../../../lib/qmin'

describe 'Qmin::Reporting::Inline' do
  let(:error_producer){ TestClass.new(123) }

  it 'raises error with default inline strategy' do
    lambda{
      error_producer.raise_error
    }.should raise_error(TestClass::CustomError)
  end

  it 'raises no error with noop strategy' do
    Qmin::Qmin.default_strategy = Qmin::Strategy::Noop
    lambda{
      error_producer.raise_error
    }.should_not raise_error(TestClass::CustomError)
  end

  describe 'resque strategy' do
    before do
      Qmin::Qmin.default_strategy = Qmin::Strategy::Resque
    end

    it 'raises no error with resque strategy when enqueueing the job' do
      lambda{
        error_producer.raise_error
      }.should_not raise_error(TestClass::CustomError)
    end

    it 'raises error when job is performing' do
      lambda{
        Qmin::Resque::BackgroundCallJob.new(TestClass, :raise_error, error_producer.id).perform
      }.should raise_error(TestClass::CustomError)
    end
  end

end

