# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  include FetchOrFallbackHelper
  include HeroiconHelper

  delegate(
    :browser,
    :dom_id,
    :highlight,
    :options_for_select,
    :select_tag,
    :turbo_frame_tag,
    to: :helpers
  )
end
