pragma solidity ^0.4.23;


    contract ERC20Basic {
        uint256 public totalSupply;
        
        function balanceOf(address who) public constant returns  (uint256);
        function transfer(address to, uint256 value) public returns (bool);
        
            event Transfer(address indexed from, address indexed to, uint256 value);
}


contract ERC20 is ERC20Basic {
        
        function allowance(address owner, address spender) public constant returns (uint256);
        function transferFrom(address from, address to, uint256 value) public returns (bool);
        function approve(address spender, uint256 value) public returns (bool);
    
        event Approval(address indexed owner, address indexed spender, uint256 value);
}


library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) 
        {return 0;}
        c = a*b;
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
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }


    function balanceOf(address _owner) public constant returns (uint256 balance) {
        
        return balances[_owner];
    }

}


contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) allowed;


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        uint256 _allowance = allowed[_from][msg.sender];

        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
  }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}


contract Ownable {
    
    address public owner;
    
    
    constructor() public {                                                      //OWNABLE
        owner = msg.sender;
    }


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));      
        owner = newOwner;
    }

}

contract BurnableToken is StandardToken {


    function burn(uint _value) public {
        require(_value > 0);
        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        emit Burn(burner, _value);
    }

    event Burn(address indexed burner, uint indexed value);

}

contract SimpleCoinToken is BurnableToken {
    
    string public constant name = "Alpabet";
   
    string public constant symbol = "ABC";
    
    uint32 public constant decimals = 18;

    uint256 public INITIAL_SUPPLY = 500000000 * 10**18;

    constructor() public {                                                      //SimpleCoinToken
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
    
}
