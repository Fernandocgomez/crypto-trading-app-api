class PortafoliosController < ApplicationController

    def show # Tested and working
        portafolio = Portafolio.find_by(id: params[:id])
        render json: portafolio.to_json(:only => [:id, :name, :balance])
    end

    # Tested and working
    # it takes :balance (format 10.99)
    # takes the portafolio id as url params 
    def add_funds 
        portafolio = Portafolio.find(params[:id])
        portafolio.update(balance: portafolio.balance + portafolio_params[:balance].to_f)
        render json: {portafolio: PortafolioSerializer.new(portafolio), message: "funds were added"}
    end


    # Tested and working 
    # takes the id of the portafolio as url params
    # put method
    def update_price_on_portafolio 
        portafolio = Portafolio.find(params[:id])
        return render json: {message: "You don't have any crypto assest"} if portafolio.crypto_assets.size == 0
        for i in portafolio.crypto_assets
            url = "https://api.coincap.io/v2/assets/#{i.cryptoId}"
            response = HTTParty.get(url)
            result = JSON.parse(response.body)
            i.update(
                supply: result.dig("data", "supply"), 
                maxSupply: result.dig("data", "maxSupply"), 
                marketCapUsd: result.dig("data", "marketCapUsd"),
                priceUsd: result.dig("data", "priceUsd"),
                changePercent24Hr: result.dig("data", "changePercent24Hr"),
                rank: result.dig("data", "rank"),
                volumeUsd24Hr: result.dig("data", "volumeUsd24Hr"),
            )
        end
        render json: {my_crypto_assests: portafolio.crypto_assets}
    end

    private 

    def portafolio_params
        params.permit(:balance)
    end
    
end
