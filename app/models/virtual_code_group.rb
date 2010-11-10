class VirtualCodeGroup < ActiveRecord::Base
  belongs_to :user
  has_many :virtual_codes, :dependent => :destroy

  validates_presence_of :title, :user
end
