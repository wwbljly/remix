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

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor() {
        _name = "WBCoin";
        _symbol = "WBC";
        _decimals = 18;
        _mint(msg.sender, 100 * 10000 * 10**_decimals);
    }

    // ====取值器======

    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return _balances[_owner];
    }
    function allowancesOf(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
    // ====取值器======


    // ====函数======
    // 转账
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    //授权代币转发
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_value > 1000, "minValue 1000");
        address owner = msg.sender;
        _approve(owner, _spender, _value);
        return true;
    }
    function transferFrom(address from, address to, uint256 amount) public returns (bool success){
        address owner = msg.sender;
        _spendAllowance(from,owner,amount);
        _transfer(from, to, amount);
        return true;
    }
    // ====函数======




    // 合约内部函数
    // 初始化
    function _mint(address account,uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        // 初始化货币数量
        _totalSupply += amount;
        // 初始化账号注入资金
        unchecked {
            _balances[account] += amount;
        }
    }
    //转账
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer from balance insufficient");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }
    }
    //授权
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: _approve owner the zero address");
        require(spender != address(0), "ERC20: _approve spender the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner,spender,amount);
    }
    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 current = allowancesOf(owner, spender);
        if(current != type(uint256).max) {
            require(current>=amount,"ERC20: _approve balance insufficient");
            unchecked {
                _approve(owner,spender,current-amount);
            }
        }
    }
    // 合约内部函数
}


