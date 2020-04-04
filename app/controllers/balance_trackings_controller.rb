class BalanceTrackingsController < ApplicationController
    
    # Create a hourly record of how much the all the users owns in crypto converted to USD
    # Tested and working
    def hourly_tracking 
        time = Time.now.in_time_zone("Central Time (US & Canada)").strftime('%a, %d %b %Y %H:%M:%S')
        portafolios = Portafolio.all
        for c in  portafolios
            all_own_in_usd = []
            all_cryptos = c.crypto_assets
            for i in all_cryptos
                url = "https://api.coincap.io/v2/assets/#{i.cryptoId}"
                response = HTTParty.get(url)
                result = JSON.parse(response.body)
                latest_price = result.dig("data", "priceUsd").to_f
                how_much_own = (latest_price * i.crypto_Percentage)/100
                all_own_in_usd << how_much_own
            end
            BalanceTracking.create(total: all_own_in_usd.sum, portafolio_id: c.id, date_time: time)
        end
    end

end
