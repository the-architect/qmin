require File.expand_path '../../spec_helper', File.dirname(__FILE__)
require File.expand_path '../../../lib/qmin', File.dirname(__FILE__)

describe 'Qmin::Reporting::Mail' do

  before do
    Qmin::Reporting::Mail.setup_delivery :test
    Qmin::Reporting::Mail.setup_mail 'receiver@example.com', 'error-notification@mydomain.com'
    Qmin::Qmin.default_reporter = Qmin::Reporting::Mail
  end

  after do
    Mail::TestMailer.deliveries.clear
    Qmin::Qmin.default_reporter = nil
  end

  let(:error_producer){ TestClass.new(123) }

  it 'raises error for inline strategy' do
    lambda{
      error_producer.raise_error
    }.should raise_error(TestClass::CustomError)
  end

  describe 'resque strategy' do
    before do
      Qmin::Qmin.default_strategy = Qmin::Strategy::Resque
    end

    it 'raises no error with resque strategy when enqueuing the job' do
      lambda{
        error_producer.raise_error
      }.should_not raise_error
    end

    it 'raises error when job is performing' do
      lambda{
        Qmin::Resque::BackgroundCallJob.new(TestClass, :raise_error, error_producer.id).perform
      }.should_not raise_error

      Mail::TestMailer.deliveries.should_not be_empty
    end
  end


end
