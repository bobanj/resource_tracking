require 'lib/ActAsDataElement'
require 'lib/BudgetSpendHelpers'

class Activity < ActiveRecord::Base
  ### Class constants
  STRAT_PROG_TO_CODES_FOR_TOTALING = {
    "Quality Assurance" => ["6","7","8","9","11"],
    "Commodities, Supply and Logistics" => ["5"],
    "Infrastructure and Equipment" => ["4"],
    "Health Financing" => ["3"],
    "Human Resources for Health" => ["2"],
    "Governance" => ["101","103"],
    "Planning and M&E" => ["102","104","105","106"]
  }

  STRAT_OBJ_TO_CODES_FOR_TOTALING = {
    "Across all 3 objectives" => ["1","201","202","203","204","206","207","208","3","4","5","7","11"],
    "b. Prevention and control of diseases" => ['205','9'],
    "c. Treatment of diseases" => ["601","602","603","604","607","608","6011","6012","6013","6014","6015","6016"],
    "a. FP/MCH/RH/Nutrition services" => ["605","609","6010", "8"]
  }

  BUDGET_CODING_CLASSES = ['CodingBudget', 'CodingBudgetDistrict', 'CodingBudgetCostCategorization']

  ### Includes
  include ActAsDataElement
  include BudgetSpendHelpers #TODO: deprecate with Money methods
  acts_as_commentable
  include MoneyHelper
  configure_act_as_data_element

  ### Attributes
  attr_accessible :projects, :locations, :beneficiaries, :provider,
                  :text_for_provider, :text_for_beneficiaries,
                  :text_for_targets, :name, :description, :start, :end,
                  :approved, :budget, :spend, :spend_q4_prev,
                  :spend_q1, :spend_q2, :spend_q3, :spend_q4

  ### Associations
  belongs_to :provider, :foreign_key => :provider_id, :class_name => "Organization"
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :organizations # organizations targeted by this activity / aided
  has_and_belongs_to_many :beneficiaries # codes representing who benefits from this activity
  has_many :sub_activities, :class_name => "SubActivity",
                            :foreign_key => :activity_id,
                            :dependent => :destroy
  has_many :sub_implementers, :through => :sub_activities, :source => :provider
  has_many :codes, :through => :code_assignments
  has_many :code_assignments, :dependent => :destroy
  # specific code_assignments by type
  has_many :coding_budget
  has_many :coding_budget_cost_categorization
  has_many :coding_budget_district
  has_many :coding_spend
  has_many :coding_spend_cost_categorization
  has_many :coding_spend_district

  ### Validations
  validate :approved_activity_cannot_be_changed

  ### Callbacks
  before_save :update_cached_usd_amounts
  before_update :remove_district_codings
  before_update :update_all_classified_amount_caches
  after_save  :update_counter_cache
  after_destroy :update_counter_cache

  ### Named scopes
  named_scope :roots,             {:conditions => "activities.type IS NULL" }
  named_scope :greatest_first,    {:order => "activities.budget DESC" }
  named_scope :with_type,         lambda { |type| {:conditions => ["activities.type = ?", type]} }
  named_scope :only_simple,       { :conditions => ["activities.type IS NULL
                                    OR activities.type IN (?)", ["OtherCost"]] }
  named_scope :with_a_project,    { :conditions => "activities.id IN (SELECT activity_id FROM activities_projects)" }
  named_scope :without_a_project, { :conditions => "activities.id NOT IN (SELECT activity_id FROM activities_projects)" }
  named_scope :implemented_by_health_centers, { :joins => [:provider], :conditions => ["organizations.raw_type = ?", "Health Center"]}
  named_scope :canonical_with_scope, {
    :select => 'DISTINCT activities.*',
    :joins =>
      "INNER JOIN data_responses
        ON activities.data_response_id = data_responses.id
      LEFT JOIN data_responses provider_dr
        ON provider_dr.organization_id = activities.provider_id
      LEFT JOIN organizations ON provider_dr.organization_id = organizations.id",
    :conditions => ["activities.provider_id = data_responses.organization_id
                    OR (provider_dr.id IS NULL OR organizations.users_count = 0)"]
  }

  ### Public Class Methods

  def self.only_simple_activities(activities)
    activities.select{|s| s.type.nil? or s.type == "OtherCost"}
  end


  def self.canonical
      #note due to a data issue, we are getting some duplicates here, so i added uniq. we should fix data issue tho
      a = Activity.all(:joins =>
        "INNER JOIN data_responses ON activities.data_response_id = data_responses.id
        LEFT JOIN data_responses provider_dr ON provider_dr.organization_id = activities.provider_id
        LEFT JOIN (SELECT organization_id, count(*) as num_users
                     FROM users
                  GROUP BY organization_id) org_users_count ON org_users_count.organization_id = provider_dr.organization_id ",
       :conditions => ["activities.provider_id = data_responses.organization_id
                        OR (provider_dr.id IS NULL
                        OR org_users_count.organization_id IS NULL)"])
      a.uniq
  end

  def self.unclassified
    self.find(:all).select {|a| !a.classified}
  end

  def self.jawp_activities
    Activity.only_simple.find(:all,
      :include => [:locations, :provider, :organizations,
                  :beneficiaries, {:data_response => :organization}])
  end

  def budget_district_coding_adjusted
    district_coding(CodingBudgetDistrict, coding_budget_district, budget)
  end

  def spend_district_coding_adjusted
    district_coding(CodingSpendDistrict, coding_spend_district, spend)
  end

  def budget_stratprog_coding
    virtual_codes(HsspBudget, coding_budget, STRAT_PROG_TO_CODES_FOR_TOTALING)
  end

  def spend_stratprog_coding
    virtual_codes(HsspSpend, coding_spend, STRAT_PROG_TO_CODES_FOR_TOTALING)
  end

  def budget_stratobj_coding
    virtual_codes(HsspBudget, coding_budget, STRAT_OBJ_TO_CODES_FOR_TOTALING)
  end

  def spend_stratobj_coding
    virtual_codes(HsspSpend, coding_spend, STRAT_OBJ_TO_CODES_FOR_TOTALING)
  end

  # TODO: remove
  #convenience
  def implementer
    provider
  end

  # TODO: remove
  def start_date
    self.start
  end

  # TODO: remove
  def end_date
    self.end
  end

  def currency
    self.project.nil? ? nil : self.project.currency
  end

  # TODO change this with delegate
  def organization
    self.data_response.organization
  end

  # helper until we enforce this in the model association!
  def project
    self.projects.first unless projects.empty?
  end

  # TODO: remove
  def organization_name
    organization.name
  end

  # TODO: THIS METHOD NEEDS TO BE RENAMED TO valid_districts
  def districts
    self.projects.collect do |proj|
      proj.locations
    end.flatten.uniq
  end

  def classified
    #TODO override in othercosts and sub_activities
    budget_coded? && budget_by_district_coded? && budget_by_cost_category_coded? &&
    spend_coded? && spend_by_district_coded? && spend_by_cost_category_coded?
  end

  def classified?
    classified
  end

  def budget_coded?
    self.budget == self.CodingBudget_amount
  end

  def budget_by_district_coded?
    return true if self.locations.empty? #TODO: remove when locations are mandatory
    self.budget == self.CodingBudgetDistrict_amount
  end

  def budget_by_cost_category_coded?
    self.budget == self.CodingBudgetCostCategorization_amount
  end

  def spend_coded?
    self.spend == self.CodingSpend_amount
  end

  def spend_by_district_coded?
    return true if self.locations.empty? #TODO: remove
    self.spend == self.CodingSpendDistrict_amount
  end

  def spend_by_cost_category_coded?
    self.spend == self.CodingSpendCostCategorization_amount
  end

  def budget_classified?
    budget_coded? && budget_by_district_coded? && budget_by_cost_category_coded?
  end

  def spend_classified?
    spend_coded? && spend_by_district_coded? && spend_by_cost_category_coded?
  end

  # Called from migrations
  def update_classified_amount_cache(type)
    set_classified_amount_cache(type)
    self.save(false) # save the activity with new cached amounts event if it's approved
  end

  # Updates classified amount caches if budget or spend have been changed
  def update_all_classified_amount_caches
    if budget_changed?
      [CodingBudget, CodingBudgetDistrict, CodingBudgetCostCategorization].each do |type|
        set_classified_amount_cache(type)
      end
    end
    if spend_changed?
      [CodingSpend, CodingSpendDistrict, CodingSpendCostCategorization].each do |type|
        set_classified_amount_cache(type)
      end
    end
  end

  def budget_coding_sum_in_usd
    coding_budget.with_code_ids(Mtef.roots).sum(:cached_amount_in_usd)
  end

  def budget_district_coding_sum_in_usd(district)
    coding_budget_district.with_code_id(district).sum(:cached_amount_in_usd)
  end

  def spend_coding_sum_in_usd
    coding_spend.with_code_ids(Mtef.roots).sum(:cached_amount_in_usd)
  end

  def spend_district_coding_sum_in_usd(district)
    coding_spend_district.with_code_id(district).sum(:cached_amount_in_usd)
  end

  def virtual_codes(klass, code_assignments, code_ids_maping)
    assignments = []

    code_ids_maping.each do |code_name, code_ids|
      selected = code_assignments.select {|ca| code_ids.include?(ca.code.external_id)}
      code = Code.find_by_short_display(code_name)
      amount = selected.sum{|ca| ca.cached_amount}
      assignments << fake_ca(klass, code, amount)
    end

    assignments
  end

  # This method copies code assignments when user has chosen to use
  # budget codings for expenditure: Following code assignments are copied:
  # CodingBudget -> CodingSpend
  # CodingBudgetDistrict -> CodingSpendDistrict
  # CodingBudgetCostCategorization -> CodingSpendCostCategorization
  def copy_budget_codings_to_spend(types = BUDGET_CODING_CLASSES)
    types.each do |budget_type|
      spend_type        = budget_type.gsub(/Budget/, "Spend")
      spend_type_klass  = spend_type.constantize
      CodeAssignment.delete_all(["activity_id = ? AND type = ?", self.id, spend_type])

      # copy across the ratio, not just the amount
      code_assignments.with_type(budget_type).each do |ca|
        # TODO: move to code_assignment model as a new method
        if spend && spend > 0
          spend_ca                = ca.clone
          spend_ca.type           = spend_type
          spend_ca.amount         = spend * ca.amount / budget if ca.amount && budget && budget > 0
          spend_ca.percentage     = ca.percentage
          self.code_assignments << spend_ca
        end
      end
      self.update_classified_amount_cache(spend_type_klass)
    end
    true
  end

  def coding_progress
    coded = 0
    coded +=1 if budget_coded?
    coded +=1 if budget_by_district_coded?
    coded +=1 if budget_by_cost_category_coded?
    coded +=1 if spend_coded?
    coded +=1 if spend_by_district_coded?
    coded +=1 if spend_by_cost_category_coded?
    progress = (coded.to_f / 6) * 100
  end

  def deep_clone
    clone = self.clone
    # HABTM's
    %w[locations projects organizations beneficiaries].each do |assoc|
      clone.send("#{assoc}=", self.send(assoc))
    end
    # has-many's
    %w[code_assignments].each do |assoc|
      clone.send("#{assoc}=", self.send(assoc).collect { |obj| obj.clone })
    end
    clone
  end

  private

    def update_counter_cache
      if (dr = self.data_response)
        dr.activities_count = dr.activities.only_simple.count
        dr.activities_without_projects_count = dr.activities.roots.without_a_project.count
        dr.save(false)
      end
    end

    def set_classified_amount_cache(type)
      coding_tree = CodingTree.new(self, type)
      coding_tree.set_cached_amounts!
      self.send("#{type}_amount=", coding_tree.total)
    end

    def district_coding(klass, assignments, amount)
      #TODO we will want to be able to override / check against the derived district codings
      if assignments.present?
        assignments
      elsif sub_activities.present?
        district_codings_from_sub_activities(klass)
      elsif amount
        locations.map{|location| fake_ca(klass, location, amount / locations.size)}
      else
        []
      end
    end

    def district_codings_from_sub_activities(klass)
      code_assignments = sub_activity_distrit_code_assignments(klass)

      location_amounts = {}
      code_assignments.each do |ca|
        location_amounts[ca.code] = 0 unless location_amounts[ca.code]
        location_amounts[ca.code] += ca.cached_amount
      end

      location_amounts.map{|location, amount| fake_ca(klass, location, amount)}
    end

    def sub_activity_distrit_code_assignments(klass)
      case klass.name
      when 'CodingBudgetDistrict'
        sub_activities.collect{|sub_activity| sub_activity.budget_district_coding_adjusted }
      when 'CodingSpendDistrict'
        sub_activities.collect{|sub_activity| sub_activity.spend_district_coding_adjusted }
      end.flatten
    end

    # removes code assignments for non-existing locations for this activity
    def remove_district_codings
      activity_id           = self.id
      location_ids          = locations.map(&:id)
      code_assignment_types = [CodingBudgetDistrict, CodingSpendDistrict]
      deleted_count = CodeAssignment.delete_all(["activity_id = :activity_id AND type IN (:code_assignment_types) AND code_id NOT IN (:location_ids)",
                        {:activity_id => activity_id,
                         :code_assignment_types => code_assignment_types.map{|ca| ca.to_s},
                         :location_ids => location_ids}])

      # only if there are deleted code assignments, update the district cached amounts
      if deleted_count > 0
        code_assignment_types.each do |type|
          set_classified_amount_cache(type)
        end
      end
    end

    def approved_activity_cannot_be_changed
      errors.add(:approved, "approved activity cannot be changed") if changed? and approved and changed != ["approved"]
    end

    #currency is still derived from the parent project or DR
    def update_cached_usd_amounts
      rate = self.currency ? Money.default_bank.get_rate(self.currency, "USD") : 0
      self.budget_in_usd = (self.budget || 0) * rate
      self.spend_in_usd = (self.spend || 0) * rate
    end

    def fake_ca(klass, code, amount)
      klass.new(:activity => self, :code => code,
                :cached_amount => amount, :amount => amount)
    end
end



# == Schema Information
#
# Table name: activities
#
#  id                                    :integer         primary key
#  name                                  :string(255)
#  created_at                            :timestamp
#  updated_at                            :timestamp
#  provider_id                           :integer
#  description                           :text
#  type                                  :string(255)
#  budget                                :decimal(, )
#  spend_q1                              :decimal(, )
#  spend_q2                              :decimal(, )
#  spend_q3                              :decimal(, )
#  spend_q4                              :decimal(, )
#  start                                 :date
#  end                                   :date
#  spend                                 :decimal(, )
#  text_for_provider                     :text
#  text_for_targets                      :text
#  text_for_beneficiaries                :text
#  spend_q4_prev                         :decimal(, )
#  data_response_id                      :integer
#  activity_id                           :integer
#  budget_percentage                     :decimal(, )
#  spend_percentage                      :decimal(, )
#  approved                              :boolean
#  CodingBudget_amount                   :decimal(, )     default(0.0)
#  CodingBudgetCostCategorization_amount :decimal(, )     default(0.0)
#  CodingBudgetDistrict_amount           :decimal(, )     default(0.0)
#  CodingSpend_amount                    :decimal(, )     default(0.0)
#  CodingSpendCostCategorization_amount  :decimal(, )     default(0.0)
#  CodingSpendDistrict_amount            :decimal(, )     default(0.0)
#  budget_q1                             :decimal(, )
#  budget_q2                             :decimal(, )
#  budget_q3                             :decimal(, )
#  budget_q4                             :decimal(, )
#  budget_q4_prev                        :decimal(, )
#  comments_count                        :integer         default(0)
#  sub_activities_count                  :integer         default(0)
#  spend_in_usd                          :decimal(, )     default(0.0)
#  budget_in_usd                         :decimal(, )     default(0.0)
#

