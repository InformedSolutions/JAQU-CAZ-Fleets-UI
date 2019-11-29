# frozen_string_literal: true

module AddToSession
  def add_to_session(data = {})
    data.transform_keys!(&:to_s)
    encoded_data = RackSessionAccess.encode(vehicle_details: data)
    put RackSessionAccess.path, params: { data: encoded_data }
  end
end
