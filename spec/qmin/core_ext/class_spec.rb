require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe Class do
  it 'responds to background_method' do
    Class.new.should respond_to(:background)
  end

  describe 'instance methods' do
    it 'annotates methods' do
      klass = Class.new do
        def foo; end
        background :foo
      end
      subject = klass.new

      subject.should respond_to(:foo)
      subject.should respond_to(:foo_without_qmin)
    end

    it 'annotates many methods' do
      klass = Class.new do
        def foo; end
        def bar; end
        background :foo, :bar
      end
      subject = klass.new

      subject.should respond_to(:foo)
      subject.should respond_to(:foo_without_qmin)
      subject.should respond_to(:bar)
      subject.should respond_to(:bar_without_qmin)
    end

    it 'does not annotate original method' do
      klass = Class.new do
        def foo; end
        background :foo
        background :foo_without_qmin
      end
      subject = klass.new

      subject.should respond_to(:foo)
      subject.should respond_to(:foo_without_qmin)
      subject.should_not respond_to(:foo_without_qmin_without_qmin)
    end
  end

  describe 'class methods' do
    it 'decorates eigenclass' do
      klass = Class.new do
        class << self
          def foo; end
          background :foo
        end
      end
      klass.should respond_to(:foo)
      klass.should respond_to(:foo_without_qmin)
    end

    it 'decorates class method in eigenclass' do
      klass = Class.new do
        def self.foo; end

        class << self
          background :foo
        end
      end
      klass.should respond_to(:foo)
      klass.should respond_to(:foo_without_qmin)
    end
  end

end