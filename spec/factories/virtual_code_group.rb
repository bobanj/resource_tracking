require File.join(File.dirname(__FILE__),'./blueprint.rb')

Factory.define :virtual_code_group, :class => VirtualCodeGroup do |f|
  f.title           { Sham.code_group_name }
  f.user            { Factory.create :user }
end