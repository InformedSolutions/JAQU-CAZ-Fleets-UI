# frozen_string_literal: true

# rubocop:disable Style/StringLiterals, Layout/FirstHashElementIndentation, Metrics/MethodLength
module DebitsApiResponses
  def caz_mandates_response
    {
      "mandates" => [
        {
          "id" => "294a5714-bf0f-4972-84cf-6ff6c967d22a",
          "reference" => "1625",
          "status" => "cancelled"
        },
        {
          "id" => "4d8e677d-6ea7-4a0b-97ad-5bb0f8604367",
          "reference" => "1626",
          "status" => "active"
        },
        {
          "id" => "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "reference" => "1627",
          "status" => "error"
        }
      ]
    }
  end

  def create_payment_response
    {
      "paymentId" => "5cd7441d-766f-48ff-b8ad-1809586fea37",
      "referenceNumber" => "WYP3HNDP",
      "externalPaymentId" => "4d8e677d-6ea7-4a0b-97ad-5bb0f8604367",
      "status" => "SUCCESS",
      "userEmail" => "jan@kowalski.com"
    }
  end

  def active_mandates_response
    {
      "clearAirZones" => [
        {
           "cazId" => "87c17807-d6ec-4128-9174-9ce66cc5ed73",
           "cazName" => "Leeds",
           "mandates" => [
             {
               "id" => "5cd7441d-766f-48ff-b8ad-1809586fea37",
               "reference" => "1",
               "status" => "pending"
             }
           ]
        },
        {
           "cazId" => "90fa62ca-c9dc-48b3-81c2-66b6f0d28b38",
           "cazName" => "Birmingham",
           "mandates" => [
             {
               "id" => "55f9d425-f60b-4919-9020-b6e48d641ba4",
               "reference" => "1626",
               "status" => "active"
             },
             {
               "id" => "09b72307-e56a-4b61-802a-03eee58748ba",
               "reference" => "1627",
               "status" => "failed"
             },
             {
               "id" => "45725067-ae01-4c68-9884-8aac0f5c320b",
               "reference" => "1628",
               "status" => "cancelled"
             }
           ]
        }
      ]
    }
  end

  def mandates_response
    {
      "clearAirZones" => [
        {
           "cazId" => "87c17807-d6ec-4128-9174-9ce66cc5ed73",
           "cazName" => "Leeds",
           "mandates" => []
        },
        {
           "cazId" => "90fa62ca-c9dc-48b3-81c2-66b6f0d28b38",
           "cazName" => "Birmingham",
           "mandates" => [
             {
               "id" => "55f9d425-f60b-4919-9020-b6e48d641ba4",
               "reference" => "1626",
               "status" => "active"
             },
             {
               "id" => "09b72307-e56a-4b61-802a-03eee58748ba",
               "reference" => "1627",
               "status" => "failed"
             },
             {
               "id" => "45725067-ae01-4c68-9884-8aac0f5c320b",
               "reference" => "1628",
               "status" => "cancelled"
             }
           ]
        }
      ]
    }
  end
  # rubocop:enable Style/StringLiterals, Layout/FirstHashElementIndentation, Metrics/MethodLength
end
