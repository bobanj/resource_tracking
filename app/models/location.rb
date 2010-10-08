# == Schema Information
#
# Table name: locations
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base

  attr_accessible :name

  validates_presence_of :name

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :organizations
end
