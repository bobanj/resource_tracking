require 'fastercsv'

class Reports::FacilitiesReport < Reports::SqlReport
  @@select_list =
    %w[ organizations.name organizations.fosaid ]
  
  @@where_body = "
    FROM organizations
    WHERE organizations.fosaid is not null "
  @@code_select_array = nil
  
  def initialize
    super(@@select_list, [:name, :fosaid], @@where_body, code_select_array)
  end
 
  def code_select_array
    unless @@code_select_array
      @@code_select_array = []

      #all external ids below
   #   mtef_codes = Mtef.roots
   #   hssp_strat_prog_codes = []
   #   hssp_strat_obj_codes = []
   #   nsp_codes = [ ]
      mtef_codes = [] # %w[6 8 9].collect{|e| Mtef.find_by_external_id e}.flatten
      hssp_strat_prog_codes = [] # HsspStratProg.all
      hssp_strat_obj_codes = HsspStratObj.all
      nsp_codes = [] #Nsp.all

      [ mtef_codes, nsp_codes ].each do |codes|
          #type, code_id, result_name, header_name
        codes.each do |code|
          @@code_select_array << [CodingSpend, code.id , "a#{code.id}", "#{code.class} Spent for #{code.to_s_with_external_id}"]
          @@code_select_array << [CodingBudget, code.id , "b#{code.id}", "#{code.class} Budget for #{code.to_s_with_external_id}"]
        end
      end

      [ hssp_strat_prog_codes, hssp_strat_obj_codes ].each do |codes|
          #type, code_id, result_name, header_name
        codes.each do |code|
          @@code_select_array << [HsspSpend, code.id , "c#{code.id}", "#{code.class} Spent for #{code.to_s_with_external_id}"]
          @@code_select_array << [HsspBudget, code.id , "d#{code.id}","#{code.class} Budget for #{code.to_s_with_external_id}"]
        end
      end

    else
      @@code_select_array
    end
  end

end
