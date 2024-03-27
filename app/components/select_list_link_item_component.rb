# frozen_string_literal: true

class SelectListLinkItemComponent < ApplicationComponent
  def initialize(
    url:,
    id: nil,
    classes: "",
    target: "_blank",
    tracking_event_name: nil,
    tracking_event_properties: {}
  )
    @url = url
    @id = id
    @classes = classes
    @target = target
    @tracking_event_name = tracking_event_name
    @tracking_event_properties = tracking_event_properties
  end

  private

  attr_reader :url, :id, :classes, :target, :tracking_event_name, :tracking_event_properties

  def tracking_data_attrs
    if tracking_event_name.present?
      {
        controller: "track-link",
        track_link_event_name_value: tracking_event_name,
        track_link_properties_value: tracking_event_properties
      }
    else
      {}
    end
  end
end
