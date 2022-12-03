pragma solidity ^0.4.17;

// Converting all the values from wei to ether
contract EnergyExchange {
    address[] public sellerAddress;
    address[] public buyerAddress;

    struct Seller {
        uint EnergyOffer;
        uint Wallet;
    }

    struct Buyer {
        uint EnergyRequest;
        uint BidPrice;
        uint Wallet;
    }

    mapping(address => Seller) public SellerList;
    mapping(address => Buyer) public BuyerList;

    function AddSeller(uint sellerEnergyOffer) public {
        sellerAddress.push(msg.sender);
        SellerList[msg.sender].EnergyOffer = sellerEnergyOffer;
        SellerList[msg.sender].Wallet = 0;
    }

    function AddBuyer(uint buyerBidPrice, uint EnergyRequest) public payable {
        require(msg.value > buyerBidPrice*EnergyRequest*1000000000000000000);
        buyerAddress.push(msg.sender);
        BuyerList[msg.sender].BidPrice = buyerBidPrice;
        BuyerList[msg.sender].Wallet = msg.value;
        BuyerList[msg.sender].EnergyRequest = EnergyRequest;
    }

    function AuctionSeller() public {
        // Only Mapping 1 Seller to Highest Bidder
        uint HighestBidPrice = 0;
        address AddressHighest = 0x00;
        for (uint i = 0; i < buyerAddress.length; i++)
        {
            if (HighestBidPrice < BuyerList[buyerAddress[i]].BidPrice && BuyerList[buyerAddress[i]].Wallet != 0 && BuyerList[buyerAddress[i]].EnergyRequest > 0)
            {
                HighestBidPrice = BuyerList[buyerAddress[i]].BidPrice;
                AddressHighest = buyerAddress[i];
            }
        }

        EnergyTransfer(msg.sender, AddressHighest);
    }

    function EnergyTransfer(address seller, address buyer) public {
        uint BalanceLocalEnergy = 0;
        if (SellerList[seller].EnergyOffer > BuyerList[buyer].EnergyRequest)
        {
            BalanceLocalEnergy = BuyerList[buyer].BidPrice*BuyerList[buyer].EnergyRequest;
            SellerList[seller].EnergyOffer -= BuyerList[buyer].EnergyRequest;
            BuyerList[buyer].EnergyRequest = 0;
        }
        else 
        {
            BalanceLocalEnergy = BuyerList[buyer].BidPrice*SellerList[seller].EnergyOffer;
            BuyerList[buyer].EnergyRequest -= SellerList[seller].EnergyOffer;
            SellerList[seller].EnergyOffer = 0;
        }

        SellerList[seller].Wallet += BalanceLocalEnergy*1000000000000000000;
        BuyerList[buyer].Wallet -= BalanceLocalEnergy*1000000000000000000;
    }

    function CheckoutSeller() public payable {
        msg.sender.transfer(SellerList[msg.sender].Wallet);
        SellerList[msg.sender].Wallet = 0;
    }

    function CheckoutBuyer() public payable {
        msg.sender.transfer(BuyerList[msg.sender].Wallet);
        BuyerList[msg.sender].Wallet = 0;
    }

}
