// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.noConflict();

var get_row_id = function (element) {
  return element.parents('tr').attr('id');
};

var get_resource_id = function (element) {
  return Number(get_row_id(element).match(/\d+/)[0]);
};

var get_resource_name = function (element) {
  return element.parents('#resources').attr('class');
};

var get_form = function (element) {
  return element.parents('form');
};

var add_new_form = function (data) {
  jQuery('#placer').prepend(data);
};

var add_edit_form = function (row_id, data) {
  jQuery('#' + row_id).html('<td>' + data + '</td>').addClass("edit_row");
};

var add_new_row = function (data) {
  jQuery('table#main_table tbody').prepend(data);
};

var add_existing_row = function (row_id, data) {
  var row = jQuery('#' + row_id);
  row.replaceWith(data)
  var new_row = jQuery('#' + row_id);
  new_row.find(".rest_in_place").rest_in_place();
};

var add_form = function (data, row_id) {
  if (row_id) {
  } else {
  }
};

var add_search_form = function (element) {
  if (element.hasClass('enabled')) {
    disable_element(element);
    var resource_name = get_resource_name(element);
    jQuery.get(resource_name + '/search.js', function (data) {
      jQuery('#placer').prepend(data);
    });
  }
}

var close_form = function (element) {
  element.parents('.form_box').remove();
};

var remove_row = function (row_id) {
  jQuery("#" + row_id).remove();
};

var disable_element = function (element) {
  element.removeClass('enabled').addClass('disabled');
}

var enable_element = function (element) {
  element.removeClass('disabled').addClass('enabled');
}

var new_resource = function (element) {
  if (element.hasClass('enabled')) {
    disable_element(element);
    var resource_name = get_resource_name(element);
    jQuery.get(resource_name + '/new.js', function (data) {
      add_new_form(data);
    });
  }
};

var replaceData = function (data) {
  jQuery("#main_table tbody").html(data);
};

var search_resources = function (element, type) {
  var resource_name = get_resource_name(element);
  var form = get_form(element);
  var q = (type === "reset") ? '' : form.find("#s_q").val();

  jQuery.get(resource_name + '.js?q=' + q, function (data) {
    replaceData(data);
    if (type === "reset") {
     close_form(element);
     enable_element(jQuery(".search_btn"));
    }
  });
};

var edit_resource = function (element) {
  var row_id = get_row_id(element);
  var resource_id = get_resource_id(element)
  var resource_name = get_resource_name(element);
  jQuery.get(resource_name + '/' + resource_id + '/edit.js', function (data) {
    add_edit_form(row_id, data);
  });
};

var update_resource = function (element) {
  var row_id = get_row_id(element);
  var resource_id = get_resource_id(element)
  var resource_name = get_resource_name(element);
  var form = get_form(element);
  jQuery.post(resource_name + '/' + resource_id + '.js', form.serialize(), function (data, status, response) {
    close_form(element);
    response.status === 206 ? add_edit_form(row_id, data) : add_existing_row(row_id, data); // 206 - partial content
  });
};

var create_resource = function (element) {
  var resource_name = get_resource_name(element);
  var form = get_form(element);
  jQuery.post(resource_name + '.js', form.serialize(), function (data, status, response) {
    close_form(element);
    response.status === 206 ? add_new_form(data) : add_new_row(data); // 206 - partial content
  });
};

var show_resource = function (element) {
  var row_id = get_row_id(element);
  var resource_id = get_resource_id(element)
  var resource_name = get_resource_name(element);
  jQuery.get(resource_name + '/' + resource_id + '.js', function (data) {
    close_form(element);
    add_existing_row(row_id, data);
  });
};

var destroy_resource = function (element) {
  var row_id = get_row_id(element);
  var resource_id = get_resource_id(element)
  var resource_name = get_resource_name(element);
  jQuery.post(resource_name + '/' + resource_id + '.js', {'_method': 'delete'}, function (data) {
    remove_row(row_id);
  });
};

var get_form_type = function (element) {
  // new_form => new; edit_form => edit
  return element.parents('.form_box').attr('class').replace(/form_box /, '').split('_')[0];
}

var projects_index = {
  run: function () {

    // new
    jQuery(".new_btn").live('click', function (e) {
      e.preventDefault();
      var element = jQuery(this);
      new_resource(element);
    });

    // edit
    jQuery(".edit_btn").live('click', function (e) {
      e.preventDefault();
      var element = jQuery(this);
      edit_resource(element);
    });

    // submit
    jQuery(".submit_btn").live('click', function (e) {
      e.preventDefault();
      var element = jQuery(this);
      var form_type = get_form_type(element);

      if (form_type === "new") {
        create_resource(element);
      } else if (form_type === "edit") {
        update_resource(element);
      } else if (form_type === "search") {
        search_resources(element);
      } else {
        throw "Unknown form type: " + form_type;
      }
    });

    // cancel
    jQuery(".cancel_btn").live('click', function (e) {
      e.preventDefault();
      var element = jQuery(this);
      var form_type = get_form_type(element);

      if (form_type === "new") {
        close_form(element);
        enable_element(jQuery(".new_btn"));
      } else if (form_type === "edit") {
        show_resource(element);
      } else if (form_type === "search") {
        close_form(element);
        enable_element(jQuery(".search_btn"));
      } else {
        throw "Unknown form type:" + form_type;
      }
    });

    // destroy
    jQuery(".destroy_btn").live('click', function (e) {
      e.preventDefault();
      var element = jQuery(this);
      if (confirm('Are you sure?')) {
        destroy_resource(element);
      }
    });

    // search
    jQuery(".search_btn").live('click', function (e) {
      e.preventDefault();
      var element = jQuery(this);
      add_search_form(element);
    });

    // reset
    jQuery(".reset_btn").live('click', function (e) {
      e.preventDefault();
      var element = jQuery(this);
      search_resources(element, 'reset');
    });

  }
};

var code_assignments_show = {
  run: function () {

    /*
     * Adds collapsible checkbox tree functionality for a tab and validates classification tree
     * @param {String} tab
     *
     */
    var addCollabsibleButtons = function (tab) {
      jQuery('.' + tab + ' ul.activity_tree').collapsibleCheckboxTree({tab: tab});
      jQuery('.' + tab + ' ul.activity_tree').validateClassificationTree();
    };

    /*
     * Appends tab content 
     * @param {String} tab
     * @param {String} response
     *
     */
    var appendTab = function (tab, response) {
      jQuery("#activity_classification ." + tab).html(response);
      addCollabsibleButtons(tab);
    };

    // collapsible checkboxes for tab1
    jQuery('.tooltip').tipsy({gravity: 'e'});
    addCollabsibleButtons('tab1');

    // load budget districts
    jQuery.get('/activities/' + _activity_id + '/coding?coding_type=CodingBudgetDistrict&tab=tab2', function (response) {
      appendTab('tab2', response);
    });

    // load budget cost categorization
    jQuery.get('/activities/' + _activity_id + '/coding?coding_type=CodingBudgetCostCategorization&tab=tab3', function (response) {
      appendTab('tab3', response);
    });

    // load expenditure
    jQuery.get('/activities/' + _activity_id + '/coding?coding_type=CodingSpend&tab=tab4', function (response) {
      appendTab('tab4', response);
    });

    // load expenditure districts
    jQuery.get('/activities/' + _activity_id + '/coding?coding_type=CodingSpendDistrict&tab=tab5', function (response) {
      appendTab('tab5', response);
    });
    // load expenditure cost categories
    jQuery.get('/activities/' + _activity_id + '/coding?coding_type=CodingSpendCostCategorization&tab=tab6', function (response) {
      appendTab('tab6', response);
    });

    // bind click events for tabs
    jQuery(".nav2 ul li").click(function (e) {
      e.preventDefault();
      jQuery(".nav2 ul li").removeClass('selected');
      jQuery(this).addClass('selected');
      jQuery("#activity_classification > div").hide();
      jQuery('#activity_classification > div.' + jQuery(this).attr("id")).show();
    });

    // remove flash notice
    jQuery("#notice").fadeOut(3000);

    jQuery("#use_budget_codings_for_spend").click(function () {
      jQuery.post( "/activities/" + _activity_id + "/use_budget_codings_for_spend",
       { checked: jQuery(this).is(':checked'), "_method": "put" }
      );
    })

    jQuery("#approve_activity").click(function () {
      jQuery.post( "/activities/" + _activity_id + "/approve",
       { checked: jQuery(this).is(':checked'), "_method": "put" }
      );
    })
  }
};

var data_responses_review = {
  run: function () {
    jQuery(".use_budget_codings_for_spend").click(function () {
      activity_id = Number(jQuery(this).attr('id').match(/\d+/)[0], 10);
      jQuery.post( "/activities/" + activity_id + "/use_budget_codings_for_spend",
       { checked: jQuery(this).is(':checked'), "_method": "put" }
      );
    })
  }
}

jQuery(function () {
  var id = jQuery('body').attr("id");
  if (id) {
    controller_action = id;
    if (typeof window[controller_action] !== 'undefined') {
      window[controller_action]['run']();
    }
  }

  jQuery('#page_tips_open_link').click(function (e) {
    e.preventDefault();
    jQuery('#desc').toggle();
    jQuery('#page_tips_nav').toggle();
  });

  jQuery('#page_tips_close_link').click(function (e) {
    e.preventDefault();
    jQuery('#desc').toggle();
    jQuery('#page_tips_nav').toggle();
    jQuery("#page_tips_open_link").effect("highlight", {}, 1500);
  });


  // Date picker
  jQuery('.date_picker').live('click', function () {
    jQuery(this).datepicker('destroy').datepicker({
      changeMonth: true,
      changeYear: true,
      yearRange: '2000:2025',
      dateFormat: 'yy-mm-dd'
    }).focus();
  });

  // Collapse / expand form fieldsets
  jQuery("legend").live('click', function (e) {
    $(this).next('ol').toggle();
  })

  // Inplace edit
  jQuery(".rest_in_place").rest_in_place();
})
