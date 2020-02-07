# frozen_string_literal: true

module FleetsHelper
  def zone_colspan(index)
    index == (@zones.size - 1) ? 2 : 1
  end
end
