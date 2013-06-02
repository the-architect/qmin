require File.expand_path '../../spec_helper', File.dirname(__FILE__)

describe String do
  it '.snake_case' do
    'MyClassName'.underscore.should eql 'my_class_name'
    'Module::MyClassName'.underscore.should eql 'module/my_class_name'
  end

  it '.constantize' do
    'TestClass'.constantize.should eql TestClass
  end

  it '.to_queue_name' do
    'MyClassName'.to_queue_name.should eql 'my_class_name'
    'Module::MyClassName'.to_queue_name.should eql 'module_my_class_name'
  end

end