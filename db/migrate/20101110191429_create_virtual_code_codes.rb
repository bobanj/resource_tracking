class CreateVirtualCodeCodes < ActiveRecord::Migration
  def self.up
    create_table :virtual_code_codes do |t|
      t.integer :code_id
      t.integer :virtual_code_id

      t.timestamps
    end
  end

  def self.down
    drop_table :virtual_code_codes
  end
end
