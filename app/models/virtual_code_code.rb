class VirtualCodeCode < ActiveRecord::Base
  belongs_to :virtual_code
  belongs_to :code

  validates_presence_of :virtual_code, :code
  validates_uniqueness_of :code_id, :scope => :virtual_code_id, :message => "You have already used this code"

end
