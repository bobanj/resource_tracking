class Reports::Pie::DataResponsePie < Reports::Pie
  MAX_LEGEND_LENGTH = 10

  attr_accessor :codings

  def initialize(klass, codings_type, code_type)
    if codings_type == 'VirtualCodingBudget'
      @codings = virtual_coding_budget(klass.activities)
    else
      @codings = klass.activity_coding(codings_type, code_type)
    end
  end

  def virtual_coding_budget(activities)
    vgroup     = VirtualCodeGroup.find_by_title('NSP')
    name_value = {}
    vgroup.virtual_codes.each do |vcode|
      name_value[vcode.title] = vcode.budget_total(activities)
    end
    name_value
  end

end
