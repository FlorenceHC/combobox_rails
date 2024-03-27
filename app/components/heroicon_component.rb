# frozen_string_literal: true

class HeroiconComponent < ApplicationComponent
  SIZE_DEFAULT = :small
  SIZE_MAPPINGS = {
    :xs => 12,
    SIZE_DEFAULT => 16,
    :medium => 24,
    :large => 32,
    :xl => 48,
    :"2xl" => 64
  }
  SIZE_OPTIONS = SIZE_MAPPINGS.keys

  VARIANT_DEFAULT = :solid
  VARIANT_OPTIONS = [
    VARIANT_DEFAULT,
    :outline,
    :mini
  ]

  def initialize(icon:, size: SIZE_DEFAULT, variant: VARIANT_DEFAULT, classes: nil)
    @icon = icon
    @size = SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)]
    @variant = fetch_or_fallback(VARIANT_OPTIONS, variant, VARIANT_DEFAULT)
    @classes = classes
  end

  def render?
    @icon.present?
  end
end
