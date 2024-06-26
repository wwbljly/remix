// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract WBToken {
    //代币名称
    string private _name;
    //代币标识
    string private _symbol;
    //代币小数位
    uint8 private _decimals;
    //代币总发行量
    uint256 private _totalSupply;
    //代币数量，账户=》金额
    mapping(address => uint256) private _balances;
    //授权代币数量
    mapping(address => mapping(address => uint256)) private _allowances;


    constructor() {
        _name = "WBCoin";
        _symbol = "WBC";
        _decimals = 18;
    }


}



// function name() public view returns (string)
// function symbol() public view returns (string)
// function decimals() public view returns (uint8)
// function totalSupply() public view returns (uint256)
// function balanceOf(address _owner) public view returns (uint256 balance)
// function transfer(address _to, uint256 _value) public returns (bool success)
// function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
// function approve(address _spender, uint256 _value) public returns (bool success)
// function allowance(address _owner, address _spender) public view returns (uint256 remaining)


// event Transfer(address indexed _from, address indexed _to, uint256 _value)
// event Approval(address indexed _owner, address indexed _spender, uint256 _value)