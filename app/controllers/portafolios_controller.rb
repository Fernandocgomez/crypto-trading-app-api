class PortafoliosController < ApplicationController

    def show # Tested and working
        portafolio = Portafolio.find_by(id: params[:id])
        render json: portafolio.to_json(:only => [:id, :name, :balance])
    end

    def add_funds
        # portafolio = Portafolio.find(params[:id])
        # portafolio.update(balance: portafolio.balance + portafolio_params[:balance].to_f)
        # render json: {portafolio: PortafolioSerializer.new(portafolio), message: "funds were added"}
        
    end

    def update_price_on_portafolio 
        portafolio = Portafolio.find(params[:id])
        return render json: {message: "You don't have any crypto assest"} if portafolio.crypto_assets.size == 0
        for i in portafolio.crypto_assets
            url = "https://api.coincap.io/v2/assets/#{i.crypto_id}"
            response = HTTParty.get(url)
            result = JSON.parse(response.body)
            i.update(
                supply: result.dig("data", "supply"), 
                max_supply: result.dig("data", "maxSupply"), 
                market_cap_usd: result.dig("data", "marketCapUsd"),
                price_usd: result.dig("data", "priceUsd"),
                vwap_24_hr: result.dig("data", "vwap24Hr")
            )
        end
        render json: {my_crypto_assests: portafolio.crypto_assets}
    end

    private 

    def portafolio_params
        params.permit(:balance)
    end
    
end
