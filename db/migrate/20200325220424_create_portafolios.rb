class CreatePortafolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portafolios do |t|
      t.string :name
      t.integer :user_id
      t.float :balance

      t.timestamps
    end
  end
end
