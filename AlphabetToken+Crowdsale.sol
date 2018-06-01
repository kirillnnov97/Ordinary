pragma solidity ^0.4.24;


contract ERC20Basic {
  uint256 public totalSupply;
  
  function balanceOf(address who) public view returns (uint256);
  
  function transfer(address to, uint256 value) public returns (bool);
  
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);

  function transferFrom(address from, address to, uint256 value) public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return a / b;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;


  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner,address _spender)public view returns (uint256){
    return allowed[_owner][_spender];
  }

  function increaseApproval(address _spender, uint _addedValue) public returns (bool){
    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender,uint _subtractedValue)public returns (bool){
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract Ownable {
  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

}

contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value);

  function burn(uint256 _value) public {
    _burn(msg.sender, _value);
  }

  function _burn(address _who, uint256 _value) internal {
    balances[_who] = balances[_who].sub(_value);
    totalSupply = totalSupply.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
}

contract SimpleCoinToken is BurnableToken {
    
    string public constant name = "Alpabet";
   
    string public constant symbol = "ABC";
    
    uint32 public constant decimals = 18;

    uint256 public INITIAL_SUPPLY = 500000000 * 1 ether;

    constructor() public {                                                      //SimpleCoinToken
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
    
}

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

