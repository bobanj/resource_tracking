class DefaultValuesForAllDecimalFields < ActiveRecord::Migration
  def self.up
    change_column :activities, :budget, :decimal, :default => 0
    change_column :activities, :spend_q1, :decimal, :default => 0
    change_column :activities, :spend_q2, :decimal, :default => 0
    change_column :activities, :spend_q3, :decimal, :default => 0
    change_column :activities, :spend_q4, :decimal, :default => 0
    change_column :activities, :spend, :decimal, :default => 0
    change_column :activities, :spend_q4_prev, :decimal, :default => 0
    change_column :activities, :budget_percentage, :decimal, :default => 0
    change_column :activities, :spend_percentage, :decimal, :default => 0
    change_column :activities, :budget_q1, :decimal, :default => 0
    change_column :activities, :budget_q2, :decimal, :default => 0
    change_column :activities, :budget_q3, :decimal, :default => 0
    change_column :activities, :budget_q4, :decimal, :default => 0
    change_column :activities, :budget_q4_prev, :decimal, :default => 0

    change_column :code_assignments, :amount, :decimal, :default => 0
    change_column :code_assignments, :percentage, :decimal, :default => 0
    change_column :code_assignments, :sum_of_children, :decimal, :default => 0

    change_column :currencies, :toRWF, :decimal, :default => 0

    change_column :funding_flows, :budget, :decimal, :default => 0
    change_column :funding_flows, :spend_q1, :decimal, :default => 0
    change_column :funding_flows, :spend_q2, :decimal, :default => 0
    change_column :funding_flows, :spend_q3, :decimal, :default => 0
    change_column :funding_flows, :spend_q4, :decimal, :default => 0
    change_column :funding_flows, :spend, :decimal, :default => 0
    change_column :funding_flows, :spend_q4_prev, :decimal, :default => 0
    change_column :funding_flows, :budget_q1, :decimal, :default => 0
    change_column :funding_flows, :budget_q2, :decimal, :default => 0
    change_column :funding_flows, :budget_q3, :decimal, :default => 0
    change_column :funding_flows, :budget_q4, :decimal, :default => 0
    change_column :funding_flows, :budget_q4_prev, :decimal, :default => 0

    change_column :projects, :budget, :decimal, :default => 0
    change_column :projects, :spend, :decimal, :default => 0
    change_column :projects, :entire_budget, :decimal, :default => 0
    change_column :projects, :spend_q1, :decimal, :default => 0
    change_column :projects, :spend_q2, :decimal, :default => 0
    change_column :projects, :spend_q3, :decimal, :default => 0
    change_column :projects, :spend_q4, :decimal, :default => 0
    change_column :projects, :spend_q4_prev, :decimal, :default => 0
    change_column :projects, :budget_q1, :decimal, :default => 0
    change_column :projects, :budget_q2, :decimal, :default => 0
    change_column :projects, :budget_q3, :decimal, :default => 0
    change_column :projects, :budget_q4, :decimal, :default => 0
    change_column :projects, :budget_q4_prev, :decimal, :default => 0
  end

  def self.down
    change_column :activities, :budget, :decimal
    change_column :activities, :spend_q1, :decimal
    change_column :activities, :spend_q2, :decimal
    change_column :activities, :spend_q3, :decimal
    change_column :activities, :spend_q4, :decimal
    change_column :activities, :spend, :decimal
    change_column :activities, :spend_q4_prev, :decimal
    change_column :activities, :budget_percentage, :decimal
    change_column :activities, :spend_percentage, :decimal
    change_column :activities, :budget_q1, :decimal
    change_column :activities, :budget_q2, :decimal
    change_column :activities, :budget_q3, :decimal
    change_column :activities, :budget_q4, :decimal
    change_column :activities, :budget_q4_prev, :decimal

    change_column :code_assignments, :amount, :decimal
    change_column :code_assignments, :percentage, :decimal
    change_column :code_assignments, :sum_of_children, :decimal

    change_column :currencies, :toRWF, :decimal

    change_column :funding_flows, :budget, :decimal
    change_column :funding_flows, :spend_q1, :decimal
    change_column :funding_flows, :spend_q2, :decimal
    change_column :funding_flows, :spend_q3, :decimal
    change_column :funding_flows, :spend_q4, :decimal
    change_column :funding_flows, :spend, :decimal
    change_column :funding_flows, :spend_q4_prev, :decimal
    change_column :funding_flows, :budget_q1, :decimal
    change_column :funding_flows, :budget_q2, :decimal
    change_column :funding_flows, :budget_q3, :decimal
    change_column :funding_flows, :budget_q4, :decimal
    change_column :funding_flows, :budget_q4_prev, :decimal

    change_column :projects, :budget, :decimal
    change_column :projects, :spend, :decimal
    change_column :projects, :entire_budget, :decimal
    change_column :projects, :spend_q1, :decimal
    change_column :projects, :spend_q2, :decimal
    change_column :projects, :spend_q3, :decimal
    change_column :projects, :spend_q4, :decimal
    change_column :projects, :spend_q4_prev, :decimal
    change_column :projects, :budget_q1, :decimal
    change_column :projects, :budget_q2, :decimal
    change_column :projects, :budget_q3, :decimal
    change_column :projects, :budget_q4, :decimal
    change_column :projects, :budget_q4_prev, :decimal
  end
end
