# frozen_string_literal: true

class SelectedItemComponent < ApplicationComponent
  def initialize(hidden_id_field:)
    @hidden_id_field = hidden_id_field
  end

  private

  attr_reader :hidden_id_field
end
