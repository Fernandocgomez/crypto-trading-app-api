class BalanceTrackingsController < ApplicationController

    # skip_before_action :check_authentication, only: [:portfolio_balance_tracking]
    
    # Create a hourly record of how much the all the users owns in crypto converted to USD
    # Tested and working
    
    def hourly_tracking 
        time = Time.now.in_time_zone("Central Time (US & Canada)").strftime('%d %b %Y %H:%M')
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

    # get all the BalanceTracking record assioted with an spesific portafolio
    # Get request
    # takes portafolio id
    # you will need to pass the token on the headers
    def portfolio_balance_tracking
        total = []
        date_time = []
        portafolio = Portafolio.find_by(id: params[:id])
        portafolio.balance_trackings.each do |record|
            total << record.total
            date_time << record.date_time
        end
        render json: {total: total, date_time: date_time}
    end

    private 

    # def balance_tracking_params
    #     params.permit(:id)
    # end
end
