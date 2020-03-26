class Portafolio < ApplicationRecord
    has_many :crypto_assets
    belongs_to :user

end
