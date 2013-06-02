require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe Class do
  it 'responds to background_method' do
    Class.new.should respond_to(:background_method)
  end

  it 'annotates methods' do
    klass = Class.new do
      def foo; end
      background_method :foo

      def bar; end
      background_method :bar
    end

    subject = klass.new

    subject.should.respond_to? :foo
    subject.should.respond_to? :foo_without_qmin

    subject.should.respond_to? :bar
    subject.should.respond_to? :bar_without_qmin
  end


  it 'annotates many methods' do
    klass = Class.new do
      def foo; end
      def bar; end

      background_methods :foo, :bar
    end

    subject = klass.new

    subject.should.respond_to? :foo
    subject.should.respond_to? :foo_without_qmin

    subject.should.respond_to? :bar
    subject.should.respond_to? :bar_without_qmin
  end

  it 'does not annotate method twice' do
    klass = Class.new do
      def foo; end
      background_method :foo
      background_method :foo
    end

    subject = klass.new

    subject.should.respond_to? :foo
    subject.should.respond_to? :foo_without_qmin
  end

  it 'does not annotate original method' do
    klass = Class.new do
      def foo; end
      background_method :foo
      background_method :foo_without_qmin
    end

    subject = klass.new

    subject.should.respond_to? :foo
    subject.should.respond_to? :foo_without_qmin
    subject.should_not.respond_to? :foo_without_qmin_without_qmin
  end
end