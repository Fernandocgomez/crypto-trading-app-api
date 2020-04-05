desc "Create a hourly record of how much the all the users owns in crypto converted to USD"
task :hourly_track => :environment do
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
        formated_ammount = all_own_in_usd.sum.round(2)
        BalanceTracking.create(total: formated_ammount, portafolio_id: c.id, date_time: time)
    end
end
