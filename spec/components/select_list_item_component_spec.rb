# frozen_string_literal: true

require "rails_helper"

RSpec.describe SelectListItemComponent, type: :component do
  it "renders a hidden input field with select_field_name, item, and item_value_method" do
    user = User.find(1)

    result = render_inline described_class.new(
      item: user,
      item_value_method: :name,
      select_field_name: "user_name"
    ) do |component|
      component.with_selected_item { "Item" }
    end

    template_inner_html = template_inner_html(result)

    expect(template_inner_html).to have_css(
      <<~CSS.delete("\n"),
        input
        [name='user_name']
        [type='hidden']
        [id='user_1']
        [autocomplete='off']
        [value='#{user.name}']
      CSS
      visible: :all
    )
  end

  # Workaround for matching inside <template> tags
  # https://github.com/teamcapybara/capybara/issues/2510
  def template_inner_html(document_fragment)
    document_fragment.css("template").first.inner_html
  end
end
