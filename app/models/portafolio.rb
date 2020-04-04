class Portafolio < ApplicationRecord
    has_many :crypto_assets
    has_many :balance_trackings
    belongs_to :user

end
