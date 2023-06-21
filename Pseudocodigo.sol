pragma solidity >=0.4.22 <0.7.0;

contract PlainVanillaBond {
    address public owner;
    uint256 public coupon;
    uint256 public maturity;
    mapping (address => bool) public KYCCompleted;
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(uint256 _coupon, uint256 _maturity) public {
        owner = msg.sender;
        coupon = _coupon;
        maturity = _maturity;
    }

    function completeKYC(address _investor) public {
        require(msg.sender == owner);
        KYCCompleted[_investor] = true;
    }

    function purchase(address _investor, uint256 _value) public {
        require(KYCCompleted[_investor]);
        require(msg.value == _value);
        balanceOf[_investor] += _value;
    }

    function payoutCoupons() public {
        require(msg.sender == owner);
        require(now >= maturity);
        for (address _investor in balanceOf.keys) {
            _investor.transfer(balanceOf[_investor] * coupon);
        }
    }
}
