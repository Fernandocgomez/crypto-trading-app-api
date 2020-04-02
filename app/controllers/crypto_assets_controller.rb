class CryptoAssetsController < ApplicationController

    def index # Tested and working
        crypto_assets = CryptoAsset.all
        render json: crypto_assets.to_json()
    end

    def show # Tested and working
        crypto_asset = CryptoAsset.find_by(id: params[:id])
        render json: crypto_asset.to_json()
    end

    # function is tested and working
    # Params need :cryptoId, :name, :rank, :symbol, :supply, :maxSupply, :marketCapUsd, :volumeUsd24Hr, :priceUsd, :changePercent24Hr, :portafolio_id
    # Params need :ammount_pass (format: 11.03)
    # This is a post request
    def buy_crypto 
        portafolio = Portafolio.find_by(id: crypto_params[:portafolio_id])
        if portafolio.balance >= buy_crypto_ammount_params[:ammount_pass].to_f
            percentage_being_buy = (buy_crypto_ammount_params[:ammount_pass].to_f * 100)/crypto_params[:priceUsd].to_f
            crypto_in_record = portafolio.crypto_assets.find_by(cryptoId: crypto_params[:cryptoId])
            if crypto_in_record == nil
                portafolio.update(balance: portafolio.balance - buy_crypto_ammount_params[:ammount_pass].to_f)
                new_crypto = CryptoAsset.create(
                    cryptoId: crypto_params[:cryptoId], 
                    name: crypto_params[:name],
                    rank: crypto_params[:rank],
                    symbol: crypto_params[:symbol],
                    supply: crypto_params[:supply],
                    maxSupply: crypto_params[:maxSupply],
                    marketCapUsd: crypto_params[:marketCapUsd],
                    volumeUsd24Hr: crypto_params[:volumeUsd24Hr],
                    priceUsd: crypto_params[:priceUsd],
                    changePercent24Hr: crypto_params[:changePercent24Hr],
                    crypto_Percentage: percentage_being_buy, 
                    portafolio_id: crypto_params[:portafolio_id],
                )
                render json: {new_crypto: new_crypto, portafolio: portafolio}
            else
                portafolio.update(balance: portafolio.balance - buy_crypto_ammount_params[:ammount_pass].to_f)
                new_crypto = CryptoAsset.create(
                    cryptoId: crypto_params[:cryptoId], 
                    name: crypto_params[:name],
                    rank: crypto_params[:rank],
                    symbol: crypto_params[:symbol],
                    supply: crypto_params[:supply],
                    maxSupply: crypto_params[:maxSupply],
                    marketCapUsd: crypto_params[:marketCapUsd],
                    volumeUsd24Hr: crypto_params[:volumeUsd24Hr],
                    priceUsd: crypto_params[:priceUsd],
                    changePercent24Hr: crypto_params[:changePercent24Hr],
                    crypto_Percentage: percentage_being_buy + crypto_in_record.crypto_Percentage, 
                    portafolio_id: crypto_params[:portafolio_id],
                )
                crypto_in_record.destroy
                render json: {new_crypto: new_crypto, portafolio: portafolio}
            end
        else
            render json: {error: "You don't have enough funds"}
        end
    end

    
    # function is tested and working
    # You need the id of the crypto
    # params need :rank, :supply, :maxSupply, :marketCapUsd, :volumeUsd24Hr, :priceUsd, :changePercent24Hr
    # params need :ammount (fomrat 10.30)
    # This is a put method
    def sell_crypto
        crypto = CryptoAsset.find_by(id: params[:id])
        crypto.update(sell_crypto_params_update)
        amount_owned_usd = (crypto.crypto_Percentage * crypto.priceUsd.to_f)/100
        byebug
        if sell_crypto_params[:ammount].to_f <= amount_owned_usd.round(2)
            if sell_crypto_params[:ammount].to_f == amount_owned_usd.round(2)
                crypto.portafolio.update(balance: crypto.portafolio.balance + amount_owned_usd)
                crypto.destroy
                render json: {message: "100% of the crypto was sold"}
            else
                new_ammount = amount_owned_usd - sell_crypto_params[:ammount].to_f
                new_percentage = (new_ammount * 100)/crypto.priceUsd.to_f
                crypto.portafolio.update(balance: crypto.portafolio.balance + sell_crypto_params[:ammount].to_f)
                crypto.update(crypto_Percentage: new_percentage)
                render json: {new_crypto_value: crypto}
            end
        else
            render json: {message: "You don't have enough funds"}, status: :not_acceptable
        end
    end 

    private 

    def crypto_params
        params.permit(:cryptoId, :name, :rank, :symbol, :supply, :maxSupply, :marketCapUsd, :volumeUsd24Hr, :priceUsd, :changePercent24Hr, :portafolio_id)
    end

    def sell_crypto_params
        params.permit(:ammount)
    end

    def sell_crypto_params_update
        params.permit(:rank, :supply, :maxSupply, :marketCapUsd, :volumeUsd24Hr, :priceUsd, :changePercent24Hr)
    end

    def buy_crypto_ammount_params
        params.permit(:ammount_pass)
    end


end
