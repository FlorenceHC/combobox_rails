# frozen_string_literal: true

class SelectComponent < ApplicationComponent
  NullUrl = OpenStruct.new(
    present?: false,
    to_s: ""
  )

  def initialize(
    form:,
    name:,
    label: nil,
    label_visible: true,
    placeholder: nil,
    classes: "",
    action: nil,
    multiple: false,
    required: false,
    fetch_url: NullUrl,
    new_item_param_name: nil,
    fetch_frame_id: "search-results",
    fetch_field_name: "search"
  )
    @fetch_field_name = fetch_field_name
    @fetch_frame_id = fetch_frame_id
    @fetch_url = fetch_url
    @required = required
    @multiple = multiple
    @form = form
    @name = name
    @label = label
    @label_visible = label_visible
    @classes = classes
    @placeholder = placeholder
    @action = action
    @new_item_param_name = new_item_param_name
  end

  renders_one :noscript_fallback, ->(collection: []) do
    case form
    when ->(f) { f.respond_to?(:input) }
      form.input(
        name,
        label: label,
        required: required,
        collection: collection,
        multiple: multiple,
        wrapper: :tailwind_text_input
      )
    when ->(f) { f.respond_to?(:select) }
      form.select(
        name,
        collection,
        {include_blank: required},
        {
          required: required,
          multiple: multiple,
          class: token_list(
            "appearance-none block w-full",
            "px-3 py-2",
            "border border-gray-300 rounded-md shadow-sm",
            "placeholder-gray-400",
            "focus:outline-none focus:ring-indigo-500 focus:border-indigo-500",
            "sm:text-sm",
            "disabled:bg-gray-200"
          ),
          aria: {
            label: label
          }
        }
      )
    else
      raise "Form builder not yet supported"
    end
  end

  renders_many :selected_items, ->(item:, value_method: :id) do
    SelectedItemComponent.new(
      hidden_id_field: form.hidden_field(
        name,
        value: item.send(value_method),
        id: dom_id(item),
        multiple: multiple
      )
    )
  end

  renders_one :select_list, -> do
    SelectListComponent.new(
      select_field_name: form.field_name(
        name,
        multiple: multiple
      )
    )
  end

  private

  attr_reader(
    :form,
    :name,
    :fetch_url,
    :required,
    :multiple,
    :fetch_frame_id,
    :fetch_field_name,
    :classes,
    :label_visible,
    :action,
    :new_item_param_name
  )

  def reset_visible_tailwind_input_defaults
    "border: initial; outline: initial; box-shadow: initial;"
  end

  def required_classes
    "required"
  end

  def label_visible_classes
    label_visible.presence || "sr-only"
  end

  def fetch_url_with_field_name
    fetch_url.to_s + "?field_name=#{form.field_name(name, multiple: multiple)}"
  end

  def remote?
    fetch_url.present?
  end

  def placeholder
    @placeholder.presence || t("labels.type_to_search")
  end

  def label
    @label.presence || t("labels.search")
  end
end
