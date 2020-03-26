class CreateCryptoAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :crypto_assets do |t|
      t.string :name
      t.string :symbol
      t.string :supply
      t.string :max_supply
      t.string :market_cap_usd
      t.string :price_usd
      t.string :vwap_24_hr
      t.integer :units
      t.integer :portafolio_id
      t.string :crypto_id

      t.timestamps
    end
  end
end
