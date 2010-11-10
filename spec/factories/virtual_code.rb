require File.join(File.dirname(__FILE__),'./blueprint.rb')

Factory.define :virtual_code, :class => VirtualCode do |f|
  f.title               { Sham.virtual_code_name }
  f.virtual_code_group  { Factory.create :virtual_code_group }
  f.codes               { [Factory.create(:code), Factory.create(:code)] }
end