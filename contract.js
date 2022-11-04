class EnergyExchangeContract {
    prosumer(address, EnergyOffer, Wallet)
    consumer(address, EnergyRequest, BidPrice, Wallet)
    LocalEnergyTransfer(prosumer, consumer){
        if (prosumer.EnergyOffer > consumer.EnergyRequest){
            BalanceLocalEnergy = (consumer.BidPrice*consumer.EnergyRequest)
            prosumer.EnergyOffer -= consumer.EnergyRequest;
            consumer.EnergyRequest = 0;
        }
        else {
            BalanceLocalEnergy = (consumer.BidPrice*prosumer.EnergyOffer);
            consumer.EnergyRequest -= prosumer.EnergyOffer;
            prosumer.EnergyOffer = 0;
        }
        prosumer.Wallet += BalanceLocalEnergy;
        consumer.Wallet -= BalanceLocalEnergy;
    }
};