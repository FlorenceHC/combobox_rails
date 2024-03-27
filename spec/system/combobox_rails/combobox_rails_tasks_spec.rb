require "rails_helper"

RSpec.describe "Tasks" do
  it "works" do
    visit tasks_url

    expect(page).to have_css(:h1, text: "HI")
  end
end
