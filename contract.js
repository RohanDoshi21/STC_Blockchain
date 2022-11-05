class EnergyExchangeContract {
    seller(address, EnergyOffer, Wallet)
    buyer(address, EnergyRequest, BidPrice, Wallet)
    EnergyTransfer(seller, buyer){
        if (seller.EnergyOffer > buyer.EnergyRequest){
            BalanceLocalEnergy = (buyer.BidPrice*buyer.EnergyRequest)
            seller.EnergyOffer -= buyer.EnergyRequest;
            buyer.EnergyRequest = 0;
        }
        else {
            BalanceLocalEnergy = (buyer.BidPrice*seller.EnergyOffer);
            buyer.EnergyRequest -= seller.EnergyOffer;
            seller.EnergyOffer = 0;
        }
        seller.Wallet += BalanceLocalEnergy;
        buyer.Wallet -= BalanceLocalEnergy;
    }
};