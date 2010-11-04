class ChartsController < ApplicationController
  include StringCleanerHelper # gives h method

  def data_response_pie
    @data_response = DataResponse.available_to(current_user).find(params[:id])
    @assignments = @data_response.activity_coding(params[:codings_type], params[:code_type])

    send_data(get_csv_string(@assignments), :type => 'text/csv; charset=iso-8859-1; header=present')
  end

  def project_pie
    @project = Project.available_to(current_user).find(params[:id])
    @assignments = @project.activity_coding(params[:codings_type], params[:code_type])

    send_data(get_csv_string(@assignments), :type => 'text/csv; charset=iso-8859-1; header=present')
  end

  def level_one_code_targets_pie_chart

    level_one_ids = []
    Mtef.roots.each do |code|
      level_one_ids.concat(code.children.map(&:id))
    end

    @codes = Code.find(:all,
                      :select => "short_display as name, target_amount as value",
                      :conditions => ["id in (?)", level_one_ids])

    send_data(get_csv_string(@codes), :type => 'text/csv; charset=iso-8859-1; header=present')
  end

  def level_one_pie_chart
    level_one_ids = []
    Mtef.roots.each do |code|
      level_one_ids.concat(code.children.map(&:id))
    end

    @assignments = CodingBudget.with_code_ids(level_one_ids).find(:all,
      :select => "codes.short_display AS name, sum(cached_amount) AS value",
      :joins => :code,
      :group => "code_assignments.code_id")

    send_data(get_csv_string(@assignments), :type => 'text/csv; charset=iso-8859-1; header=present')
  end

  def data_response_treemap
    data_response = DataResponse.find(params[:id])

    respond_to do |format|
      format.json { render :json => Code.treemap(data_response.activities, params[:chart_type]) }
    end
  end

  def project_treemap
    project = Project.find(params[:id])

    respond_to do |format|
      format.json { render :json => Code.treemap(project.activities, params[:chart_type]) }
    end
  end

  def activity_treemap
    activity = Activity.find(params[:id])

    respond_to do |format|
      format.json { render :json => activity.treemap(params[:chart_type]) }
    end
  end

  private

  # csv format for AM pie chart:
  # title, value, ?, ?, ?, description
  def get_csv_string(records)
    other = 0
    csv_string = FasterCSV.generate do |csv|
      records.each_with_index do |record, index|
        if index < 10
          csv << [first_n_words(h(record.name), 3), record.value.to_f, nil, nil, nil, h(record.name) ]
        else
          other += record.value.to_f
        end
      end
      csv << ['Other', other, nil, nil, nil, 'Other'] if other > 0
    end
    csv_string
  end

  def first_n_words(string, n)
    string.split(' ').slice(0,n).join(' ') + '...'
  end
end
