require 'validation_disabler'
class Organization < ActiveRecord::Base
  ### Constants
  FILE_UPLOAD_COLUMNS = %w[name raw_type fosaid]

  ### Comments
  acts_as_commentable

  ### Attributes
  attr_accessible :name, :raw_type, :fosaid

  ### Associations
  has_and_belongs_to_many :activities # activities that target / aid this org
  has_and_belongs_to_many :locations
  has_many :users # people in this organization
  has_many :data_requests
  has_many :data_responses, :dependent => :destroy
  has_many :fulfilled_data_requests, :through => :data_responses, :source => :data_request
  has_many :dr_activities, :through => :data_responses, :source => :activities
  # TODO: rename organization_id_from -> from_id, organization_id_to -> to_id
  has_many :out_flows, :class_name => "FundingFlow", :foreign_key => "organization_id_from"
  has_many :in_flows, :class_name => "FundingFlow", :foreign_key => "organization_id_to"
  has_many :donor_for, :through => :out_flows, :source => :project
  has_many :implementor_for, :through => :in_flows, :source => :project
  has_many :provider_for, :class_name => "Activity", :foreign_key => :provider_id
  has_many :projects, :through => :data_responses

  ### Validations
  validates_presence_of :name
  validates_uniqueness_of :name

  ### Named scopes
  named_scope :without_users, :conditions => 'users_count = 0'
  named_scope :ordered, :order => 'name ASC, created_at DESC'

  # TODO: remove!?
  def self.remove_security
    with_exclusive_scope { find(:all) }
  end

  def is_empty?
    if users.empty? && in_flows.empty? && out_flows.empty? && provider_for.empty? && locations.empty? && activities.empty? && data_responses.select{|dr| dr.empty?}.length == data_responses.size
      true
    else
      false
    end
  end

  def unfulfilled_data_requests
    DataRequest.all - fulfilled_data_requests
  end

  def self.merge_organizations!(target, duplicate)
    ActiveRecord::Base.disable_validation!
    target.activities << duplicate.activities
    target.data_requests << duplicate.data_requests
    target.data_responses << duplicate.data_responses
    target.out_flows << duplicate.out_flows
    target.in_flows << duplicate.in_flows
    target.provider_for << duplicate.provider_for
    target.locations << duplicate.locations
    target.users << duplicate.users
    duplicate.reload.destroy # reload other organization so that it does not remove the previously assigned data_responses
    ActiveRecord::Base.enable_validation!
  end

  # TODO: write spec
  def to_s
    name
  end

  # TODO: write spec
  def user_email_list_limit_3
    users[0,2].collect{|u| u.email}.join ","
  end

  # TODO: write spec
  def short_name
    #TODO remove district name in (), capitalized, and as below
    n = name.gsub("| "+locations.first.to_s, "") unless locations.empty?
    n ||= name
    n = n.gsub("Health Center", "HC")
    n = n.gsub("District Hospital", "DH")
    n = n.gsub("Health Post", "HP")
    n = n.gsub("Dispensary", "Disp")
    n
  end

  def self.download_template
    FasterCSV.generate do |csv|
      csv << Organization::FILE_UPLOAD_COLUMNS
    end
  end

  def self.create_from_file(doc)
    saved, errors = 0, 0
    doc.each do |row|
      attributes = row.to_hash
      organization = Organization.new(attributes)
      organization.save ? (saved += 1) : (errors += 1)
    end
    return saved, errors
  end

end




# == Schema Information
#
# Table name: organizations
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  raw_type       :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  fosaid         :string(255)
#  users_count    :integer         default(0)
#  comments_count :integer         default(0)
#

