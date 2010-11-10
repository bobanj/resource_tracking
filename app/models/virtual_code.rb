class VirtualCode < ActiveRecord::Base
  belongs_to :virtual_code_group
  has_many :virtual_code_codes, :dependent => :destroy
  has_many :codes, :through => :virtual_code_codes

  validates_presence_of :title, :virtual_code_group
  validates_uniqueness_of :title, :scope => :virtual_code_group_id

  def budget_total(activities = nil)
    code_assignments_total(CodingBudget.to_s, activities)
  end

  def code_assignments_total(type, activities = nil)
    total = 0
    self.codes.each do |code|
      if activities
        assignments = code.code_assignments.with_type(type)
      else
        assignments = code.code_assignments.with_activities(activities).with_type(type)
      end
      total += assignments.sum(:cached_amount)
    end
    total
  end

end
