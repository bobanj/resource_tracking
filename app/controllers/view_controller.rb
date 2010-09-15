class ViewController < ApplicationController

  def index
    respond_to do |wants|
      wants.html {
        @graph = open_flash_chart_object( 600, 300, url_for( :action => 'index' ) )
      }
    end

  end

  def bar
    bar = BarOutline.new(50, '#9933CC', '#8010A0')
    bar.key("Page VIEWS", 10)

    10.times do |t|
            bar.data << rand(7) + 3
    end

    g = Graph.new
    g.title("BAR CHART", "{font-size: 15px;}")

    g.data_sets << bar

    g.set_x_labels(%w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct))

    g.set_x_label_style(10, '#9933CC', 0,2)
    g.set_x_axis_steps(2)
    g.set_y_max(10)
    g.set_y_label_steps(4)
    g.set_y_legend("OPENF LADF", 12, "#736AFF")
    render :text => g.render
  end


end

