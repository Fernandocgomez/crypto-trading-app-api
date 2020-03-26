class CryptoAssetSerializer < ActiveModel::Serializer
  attributes :id, :name, :symbol, :supply, :max_supply, :market_cap_usd, :price_usd, :vwap_24_hr, :portafolio_id
end
