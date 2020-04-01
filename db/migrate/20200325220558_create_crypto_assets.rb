class CreateCryptoAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :crypto_assets do |t|
      t.string :cryptoId
      t.string :name
      t.string :rank
      t.string :symbol
      t.string :supply
      t.string :maxSupply
      t.string :marketCapUsd
      t.string :volumeUsd24Hr
      t.string :priceUsd
      t.string :changePercent24Hr
      t.float :crypto_Percentage
      t.integer :portafolio_id

      t.timestamps
    end
  end
end
