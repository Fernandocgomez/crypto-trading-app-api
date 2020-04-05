class BalanceTrackingSerializer < ActiveModel::Serializer
  attributes :id, :total, :date_time
end
