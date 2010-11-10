class CreateVirtualCodes < ActiveRecord::Migration
  def self.up
    create_table :virtual_codes do |t|
      t.string :title
      t.integer :virtual_code_group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :virtual_codes
  end
end
