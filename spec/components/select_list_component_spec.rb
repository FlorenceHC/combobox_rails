# frozen_string_literal: true

require "rails_helper"

RSpec.describe SelectListComponent, type: :component do
  describe "with_fetch_result_counts" do
    it "renders the fetch result counts" do
      render_inline(described_class.new(select_field_name: "item")) do |select_list|
        select_list.with_fetch_result_counts(
          total: 100,
          visible: 10
        )
      end

      expect(page).to have_content("Showing 10 out of 100 items")
    end
  end
end
