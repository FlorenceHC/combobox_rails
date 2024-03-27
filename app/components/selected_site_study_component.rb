# frozen_string_literal: true

class SelectedSiteStudyComponent < ApplicationComponent
  def initialize(site_study:)
    @site_study = site_study
  end

  private

  attr_reader :site_study
  delegate(
    :sponsor_name,
    :sponsor_website,
    :site_location_name,
    :study_protocol_id,
    to: :site_study
  )
end
