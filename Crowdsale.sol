pragma solidity ^0.4.23;
contract Crowdsale is Ownable {
    
    using SafeMath for uint;
    
    SimpleCoinToken public token = new SimpleCoinToken();
    
    address multisig;
    address restricted;
    uint start;
    uint finish;
    uint rate;
    uint public price;
    uint public BonusData;
    uint public Date1;
    uint public Date2;
    uint public Date3;
    uint public Date4;
    
    function setPrice(uint newPrice) public onlyOwner {
        price = newPrice;
    }

    function setMultisig(address newMultisig) public onlyOwner{
        multisig = newMultisig;
    }
    
    function setrestricted(address newrestricted) public onlyOwner{
       restricted = newrestricted;
    }
    
    constructor() public {                                                     //Crowdsale
        rate = ((price.div(3).mul(100)).mul(1000000000000000000));
        start = 1525562603;
        finish = 1557098603;
    }

    modifier saleIsOn() {
        require(block.timestamp > start && block.timestamp < start + Date4 * 1 days);
        _;
    }
    
    function setBonusData(uint newBonusData) public onlyOwner {
        BonusData = newBonusData;
    }
    
     
    function setData(uint newDate1, uint newDate2, uint newDate3,  uint newDate4 ) public onlyOwner { 
        require (Date1 < Date2 && Date2 < Date3  && Date3 < Date4);
        Date1 = newDate1; 
        Date2 = newDate2; 
        Date3 = newDate3; 
        Date4 = newDate4; 
  }
    
        function createTokens() public saleIsOn payable {
            multisig.transfer(msg.value);
            uint tokens = rate.mul(msg.value).div(1 ether);
            uint bonusTokens = 0;
   
            if(block.timestamp < start + (Date1 * 1 days)) { 
                bonusTokens = tokens.div(5).mul(2); 
            } 
            else if(block.timestamp >= start + (Date1 * 1 days) && block.timestamp < start + (Date2 *1 days)) { 
                bonusTokens = tokens.div(10).mul(3); 
            } 
            else if(block.timestamp >= start +  (Date2*1 days) && block.timestamp < start + (Date3*1 days)) { 
                bonusTokens = tokens.div(5);  
            }
            else if(block.timestamp >= start + (Date3*1 days) && block.timestamp < start + (Date4* 1 days)) { 
                bonusTokens = tokens.div(10); 
            }
    
        uint tokensWithBonus = tokens.add(bonusTokens); 
            token.transfer(msg.sender, tokensWithBonus); 
        uint restrictedTokens = tokensWithBonus.mul(8).div(10); 
            token.transfer(restricted, restrictedTokens);
        uint rerestrictedTokens = tokensWithBonus.mul(2).div(10); 
            token.transfer(multisig, rerestrictedTokens);
    }

    function() external payable {
        createTokens();
    }
    
}
