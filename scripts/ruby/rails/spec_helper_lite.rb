$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'mongoid'
require 'pry'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
require 'support/mongoid'

# NOTE: make sure to change this for other projects
Mongoid::Config.connect_to('campusperks_test')

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:each) do
    clean_mongodb
  end

  def clean_mongodb
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/}.each {|c| c.find.remove_all}
  end
end

# Stubs out a module so that Rails doesn't have to be loaded when testing classes that
# make use of Rails functionality in production.
#
# An example usage:
#
# require_relative '../spec_helper_lite'
# stub_module 'ActiveModel::Conversion'
# stub_module 'ActiveModel::Naming'
#
# describe Post do
#   ...
# end
#
def stub_module(full_name)
  full_name.to_s.split(/::/).reduce(Object) do|context, name|
    begin
      context.const_get(name)
    rescue NameError
      context.const_set(name, Module.new)
    end
  end
end

