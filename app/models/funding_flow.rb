# == Schema Information
#
# Table name: funding_flows
#
#  id                   :integer         not null, primary key
#  organization_id_from :integer
#  organization_id_to   :integer
#  project_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  budget               :decimal(, )
#  spend_q1             :decimal(, )
#  spend_q2             :decimal(, )
#  spend_q3             :decimal(, )
#  spend_q4             :decimal(, )
#  organization_text    :text
#  self_provider_flag   :integer         default(0)
#  spend                :decimal(, )
#  spend_q4_prev        :decimal(, )
#  data_response_id     :integer
#

class FundingFlow < ActiveRecord::Base

  acts_as_commentable

  # Attributes
  attr_accessible :budget, :organization_text,
    :from, :to, :self_provider_flag,
    :spend, :spend_q4_prev, :spend_q1, :spend_q2, :spend_q3, :spend_q4, :project_id,
    :project, :organization_id_from, :organization_id_to
  attr_accessible :data_response

  # Validations
  validates_presence_of :project_id

  # Associations
  belongs_to :from, :class_name => "Organization", :foreign_key => "organization_id_from"
  belongs_to :to, :class_name => "Organization", :foreign_key => "organization_id_to"
  belongs_to :project
  belongs_to :data_response
  has_one :owner, :through => :data_response, :source => :responding_organization

  # Named scopes
  named_scope :sources, :conditions => "funding_flows.self_provider_flag = 0"
  named_scope :implementers, lambda {|organization| {:conditions => ["funding_flows.organization_id_from = ?", organization.id]} }
  named_scope :matching, lambda {|value, type| value.blank? ? 
    {} : {:conditions => ["organizations.name LIKE :value OR projects.name LIKE :value OR funding_flows.budget LIKE :value OR funding_flows.spend LIKE :value", {:value => "%#{value}%"}], 
    :joins => [(type == 'sources' ? "LEFT OUTER JOIN organizations ON funding_flows.organization_id_from = organizations.id" : "LEFT OUTER JOIN organizations ON funding_flows.organization_id_to = organizations.id"), "LEFT OUTER JOIN projects ON funding_flows.project_id = projects.id"].join(' ')} }
  # TODO: remove this after AS is removed!
  named_scope :available_to, lambda { |current_user|
    if current_user.role?(:admin)
      {}
    else
      {:conditions=>{:data_response_id => current_user.current_data_response.try(:id)}}
    end
  }

  def to_s
    "Flow"#: #{from.to_s} to #{to.to_s} for #{project.to_s}"
    # TODO replace when fix text flying over action links
    # in nested scaffolds
  end

  # had to add this in to solve some odd AS bug...
  def to_label
    to_s
  end
end
