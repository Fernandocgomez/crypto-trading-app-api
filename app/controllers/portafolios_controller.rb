class PortafoliosController < ApplicationController

    # Tested and working
    # This method return one user based in its id
    def show 
        portafolio = Portafolio.find_by(id: params[:id])
        render json: portafolio.to_json(:only => [:id, :name, :balance])
    end

    # Tested and working
    # it takes :balance (format 10.99)
    # takes the portafolio id as url params 
    # Put request
    # This method adds funds to a portafolio based on its id
    def add_funds 
        if portafolio_params[:balance].to_f < 0 
            render json: {portafolio: "no negative numbers are allowed"}, status: :not_acceptable

        else
            portafolio = Portafolio.find(params[:id])
            portafolio.update(balance: portafolio.balance + portafolio_params[:balance].to_f)
            render json: {portafolio: PortafolioSerializer.new(portafolio), message: "funds were added"}
        end
       
    end


    # Tested and working 
    # takes the id of the portafolio as url params
    # put method
    # This method will update all the cryptos' prices assosited to a particular portafolio
    # This method runs every time a user click on the the portafolio link on the Nav bar 
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

    # Return the total balance of own cryptos in usd as a flot 
    # Get request 
    # Takes portafolio id
    
    def available_crypto_balance_usd 
        portafolio = Portafolio.find(params[:id])
        all_own_in_usd = []
        for i in portafolio.crypto_assets
            url = "https://api.coincap.io/v2/assets/#{i.cryptoId}"
            response = HTTParty.get(url)
            result = JSON.parse(response.body)
            latest_price = result.dig("data", "priceUsd").to_f
            how_much_own = (latest_price * i.crypto_Percentage)/100
            all_own_in_usd << how_much_own
        end
        formated_ammount = all_own_in_usd.sum.round(2)
        render json: {crypto_balance_usd: formated_ammount}
    end

    private 

    def portafolio_params
        params.permit(:balance)
    end
    
end
