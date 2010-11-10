class Reports::Pie
  include StringCleanerHelper # gives h method

  attr_accessor :data

  # csv format for AM pie chart:
  # title, value, ?, ?, ?, description
  def to_csv
    other = 0
    count = 0
    csv_string = FasterCSV.generate do |csv|
      @codings.each do |name, value|
        if count < MAX_LEGEND_LENGTH
          csv << [ first_n_words(h(name), 3),
                   value.to_f,
                   nil,
                   nil,
                   nil,
                   h(name) ]
        else
          other += value.to_f
        end
        count +=1
      end
      csv << ['Other', other, nil, nil, nil, 'Other'] unless other == 0
    end
    csv_string
  end

  def first_n_words(string, n)
    string.split(' ').slice(0,n).join(' ') + '...'
  end

end
