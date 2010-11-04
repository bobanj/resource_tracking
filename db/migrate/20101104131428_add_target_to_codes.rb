class AddTargetToCodes < ActiveRecord::Migration
  def self.up
    add_column :codes, :target_amount, :decimal, :default => 0
  end

  def self.down
    remove_column :codes, :target_amount
  end
end
