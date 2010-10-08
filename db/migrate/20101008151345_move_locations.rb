class MoveLocations < ActiveRecord::Migration

  def self.up
    # drop unnecessary columns from the 'old-old' locations table,
    # which we're about to start using again
    remove_column :locations, :type

    # migrate locations (Codes => Locations)
    codes = Code.find_by_sql( "select * from codes where type = 'Location'" )
    codes.each do |code|
      location = Location.create!(:name => code.short_display)
      location.projects = code.projects
      location.activities = code.activities
      location.organizations = code.organizations
      code.destroy
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Feel free to write the reversal for this migration!"
  end
end
