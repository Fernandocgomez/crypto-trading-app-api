class CryptoAssetsController < ApplicationController

    def index # Tested and working
        crypto_assets = CryptoAsset.all
        render json: crypto_assets.to_json()
    end

    def show # Tested and working
        crypto_asset = CryptoAsset.find_by(id: params[:id])
        render json: crypto_asset.to_json()
    end

    def buy_crypto_by_unit # it takes the crypto_params 
        portafolio = Portafolio.find_by(id: crypto_params[:portafolio_id])
        total_cost = crypto_params[:units].to_f * crypto_params[:price_usd].to_f
        if portafolio.balance > total_cost
            if portafolio.crypto_assets.size == 0
                new_coin = CryptoAsset.create(crypto_params)
                portafolio.update(balance: (portafolio.balance - total_cost))
                render json: {new_coin: new_coin, portafolio: portafolio}
            else 
                currency_obj = portafolio.crypto_assets.find_by(name: crypto_params[:name])
                num_of_coins = currency_obj.units
                currency_obj.destroy
                new_coin = CryptoAsset.create(crypto_params)
                new_coin.update(units: num_of_coins + new_coin.units)
                portafolio.update(balance: (portafolio.balance - total_cost))
                render json: {portafolio: portafolio, new_crypto_value: new_coin}
            end
        else 
            render json: {message: "You don't have enough funds"}
        end
    end
    
    def sell_all_crypto
        crypto_asset = CryptoAsset.find_by(id: params[:id])
        portafolio = crypto_asset.portafolio
        portafolio.update(balance: portafolio.balance + (crypto_asset.price_usd.to_f * crypto_asset.units))
        crypto_asset.destroy
        render json: {new_balance: portafolio}
    end

    def sell_crypto_by_unit
        crypto_asset = CryptoAsset.find_by(id: params[:id])
        portafolio = crypto_asset.portafolio
        crypto_asset.update(units: (crypto_asset.units - params[:num_of_units].to_i))

        url = "https://api.coincap.io/v2/assets/#{crypto_asset.crypto_id}"
        response = HTTParty.get(url)
        result = JSON.parse(response.body)
        crypto_price = result.dig("data", "priceUsd").to_f
        portafolio.update(balance: (portafolio.balance + ( crypto_price * params[:num_of_units].to_i)))

        if crypto_asset.units == 0
            crypto_asset.destroy
        end

        render json: {crypto_asset: crypto_asset, portafolio: portafolio}
    end

    private 

    def crypto_params
        params.permit(:name, :symbol, :supply, :max_supply, :market_cap_usd, :price_usd, :vwap_24_hr, :units, :portafolio_id, :crypto_id)
    end

end
