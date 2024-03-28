# frozen_string_literal: true

class SelectListComponent < ApplicationComponent
  renders_one :no_match_state
  renders_one :fetch_result_counts, ->(visible:, total:, items_name: "items") do
    tag.p(
      showing_out_of_total(
        visible: visible,
        total: total,
        items_name: items_name
      ),
      class: "text-sm"
    )
  end

  renders_many :select_list_items, ->(item:, item_value_method: :id, classes: "") do
    SelectListItemComponent.new(
      item: item,
      item_value_method: item_value_method,
      select_field_name: select_field_name,
      classes: classes
    )
  end
  renders_many :select_list_link_items, ->(url:, id: nil, classes: nil, tracking_event_name: nil, tracking_event_properties: {}, target: nil) do
    SelectListLinkItemComponent.new(
      id: id,
      url: url,
      classes: classes,
      tracking_event_name: tracking_event_name,
      tracking_event_properties: tracking_event_properties,
      target: target
    )
  end

  def initialize(
    select_field_name:,
    classes: ""
  )
    @select_field_name = select_field_name
    @classes = classes
  end

  private

  attr_reader :select_field_name, :classes

  def showing_out_of_total(visible:, total:, items_name:)
    "Showing #{visible} out of #{total} #{items_name.pluralize}"
  end
end
