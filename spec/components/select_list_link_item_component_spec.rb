# frozen_string_literal: true

require "rails_helper"

RSpec.describe SelectListLinkItemComponent, type: :component do
  it "renders a link to the given url" do
    url = "https://example.com"

    render_inline(described_class.new(url: url)) do
      "Select List Action"
    end

    expect(page).to have_content("Select List Action")
    expect(page).to have_css("a[href='#{url}']")
  end

  it "merges classes into the link's class attribute" do
    url = "https://example.com"

    render_inline(described_class.new(
      url: url,
      classes: "test"
    ))

    expect(page).to have_css("a.test")
  end

  it "sets the id attribute on the link when given" do
    url = "https://example.com"

    render_inline(described_class.new(
      url: url,
      id: "test"
    ))

    expect(page).to have_css("a#test")
  end
end
