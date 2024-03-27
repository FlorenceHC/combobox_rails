# frozen_string_literal: true

class SelectListItemComponent < ApplicationComponent
  renders_one :selected_item, -> do
    SelectedItemComponent.new(
      hidden_id_field: hidden_field_tag(
        select_field_name,
        item.send(item_value_method),
        id: dom_id(item)
      )
    )
  end

  def initialize(
    item:,
    select_field_name:,
    item_value_method: :id,
    classes: ""
  )
    @item = item
    @select_field_name = select_field_name
    @item_value_method = item_value_method
    @classes = classes
  end

  private

  attr_reader :item, :select_field_name, :item_value_method, :classes
end
