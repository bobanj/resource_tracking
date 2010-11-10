class CreateVirtualCodeGroups < ActiveRecord::Migration
  def self.up
    create_table :virtual_code_groups do |t|
      t.string :title
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :virtual_code_groups
  end
end
