class PortafolioSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :balance
end
