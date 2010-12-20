class CodingSpend < SpendCodeAssignment

  def self.available_codes(activity = nil)
    if activity.class.to_s == "OtherCost"
      OtherCostCode.roots
    else
      Code.for_activities.roots
    end
  end
end






# == Schema Information
#
# Table name: code_assignments
#
#  id                         :integer         not null, primary key
#  activity_id                :integer
#  code_id                    :integer         indexed
#  amount                     :decimal(, )
#  type                       :string(255)
#  percentage                 :decimal(, )
#  cached_amount              :decimal(, )     default(0.0)
#  sum_of_children            :decimal(, )     default(0.0)
#  new_amount_cents           :integer         default(0), not null
#  new_amount_currency        :string(255)
#  new_cached_amount_cents    :integer         default(0), not null
#  new_cached_amount_currency :string(255)
#  new_cached_amount_in_usd   :integer         default(0), not null
#

