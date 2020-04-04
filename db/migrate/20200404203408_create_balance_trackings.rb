class CreateBalanceTrackings < ActiveRecord::Migration[6.0]
  def change
    create_table :balance_trackings do |t|
      t.float :total
      t.integer :portafolio_id
      t.string :date_time
      t.timestamps
    end
  end
end
