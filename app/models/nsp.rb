# == Schema Information
#
# Table name: codes
#
#  id                  :integer         primary key
#  parent_id           :integer
#  lft                 :integer
#  rgt                 :integer
#  short_display       :string(255)
#  long_display        :string(255)
#  description         :text
#  created_at          :timestamp
#  updated_at          :timestamp
#  start_date          :date
#  end_date            :date
#  replacement_code_id :integer
#  type                :string(255)
#  external_id         :string(255)
#  hssp2_stratprog_val :string(255)
#  hssp2_stratobj_val  :string(255)
#  official_name       :string(255)
#

class Nsp < Code

  named_scope :roots, :joins => "INNER JOIN codes AS parents ON codes.parent_id = parents.id", 
              :conditions => "codes.type = 'Nsp' AND parents.type != 'Nsp'"
  named_scope :children, :joins => "INNER JOIN codes children ON codes.id = children.parent_id",
              :conditions => "codes.type = 'Nsp' AND children.type != 'Nsp'"

end
