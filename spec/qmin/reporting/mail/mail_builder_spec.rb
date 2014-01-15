require File.expand_path '../../../spec_helper', File.dirname(__FILE__)
require File.expand_path '../../../../lib/qmin', File.dirname(__FILE__)

describe 'Qmin::Reporting::MailBuilder' do

  let(:message)   { 'Exceptional' }
  let(:backtrace) { ['Line 1', 'Line 2'] }
  let(:exception) { err = StandardError.new(message); err.set_backtrace(backtrace); err }

  let(:mail_to)   { 'receiver@example.com' }
  let(:mail_from) { 'notifier@example.com' }

  it 'builds mail' do
    mail = Qmin::Reporting::MailBuilder.new(exception, mail_to, mail_from).build
    
    mail.subject.should match(%r/#{message}$/)
    mail.body.should include(backtrace.join("\n"))
    mail.to.should eql [mail_to]
    mail.from.should eql [mail_from]
  end

end
