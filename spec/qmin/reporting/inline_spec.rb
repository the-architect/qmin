require_relative '../../spec_helper'
require_relative '../../../lib/qmin'

describe 'Qmin::Reporting::Inline' do

  error_producer = Class.new do
    def work
      raise StandardError.new
    end
    background :work
  end

  it 'raises error with default inline strategy' do
    lambda{ error_producer.new.work }.should raise_error(StandardError)
  end

  it 'raises no error with noop strategy' do
    Qmin::Qmin.default_strategy = Qmin::Strategy::Noop
    lambda{ error_producer.new.work }.should_not raise_error(StandardError)
  end

end

