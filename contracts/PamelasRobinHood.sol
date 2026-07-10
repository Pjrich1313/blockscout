// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Pamela's Robin Hood Token
 * @dev Implementation of the Robin Hood ERC-20 token for Blockscout
 * @notice Based on commit 731015d88d7e73623f2a3c097e241bc82b04ea7a (2026-07-03T14:34:44Z)
 */

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract PamelasRobinHood is IERC20 {
    string public constant name = "Pamela's Robin Hood";
    string public constant symbol = "ROBIN";
    uint8 public constant decimals = 18;
    
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    address public owner;
    bool public paused = false;
    
    // Robin Hood redistribution mechanism
    mapping(address => uint256) public contributions;
    uint256 public communityFund = 0;
    uint256 public redistributionPercentage = 2; // 2% redistribution
    
    event Redistribution(uint256 amount, uint256 timestamp);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused();
    event Unpaused();
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
    
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    /**
     * @dev Returns the total supply of tokens
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    /**
     * @dev Returns the balance of an account
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    /**
     * @dev Transfers tokens to a recipient
     */
    function transfer(address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        require(recipient != address(0), "Cannot transfer to zero address");
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        
        uint256 redistributionAmount = (amount * redistributionPercentage) / 100;
        uint256 transferAmount = amount - redistributionAmount;
        
        _balances[msg.sender] -= amount;
        _balances[recipient] += transferAmount;
        communityFund += redistributionAmount;
        contributions[msg.sender] += amount;
        
        emit Transfer(msg.sender, recipient, transferAmount);
        emit Redistribution(redistributionAmount, block.timestamp);
        
        return true;
    }
    
    /**
     * @dev Returns the allowance of a spender
     */
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    /**
     * @dev Approves a spender to transfer tokens on behalf of owner
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    /**
     * @dev Transfers tokens from sender to recipient using allowance
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        require(recipient != address(0), "Cannot transfer to zero address");
        require(_balances[sender] >= amount, "Insufficient balance");
        require(_allowances[sender][msg.sender] >= amount, "Allowance exceeded");
        
        uint256 redistributionAmount = (amount * redistributionPercentage) / 100;
        uint256 transferAmount = amount - redistributionAmount;
        
        _balances[sender] -= amount;
        _balances[recipient] += transferAmount;
        _allowances[sender][msg.sender] -= amount;
        communityFund += redistributionAmount;
        contributions[sender] += amount;
        
        emit Transfer(sender, recipient, transferAmount);
        emit Redistribution(redistributionAmount, block.timestamp);
        
        return true;
    }
    
    /**
     * @dev Returns the community fund balance
     */
    function getCommunityFund() public view returns (uint256) {
        return communityFund;
    }
    
    /**
     * @dev Distributes community fund to beneficiaries
     */
    function distributeFromCommunityFund(address[] calldata beneficiaries, uint256[] calldata amounts) public onlyOwner {
        require(beneficiaries.length == amounts.length, "Arrays must have same length");
        
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        
        require(totalAmount <= communityFund, "Insufficient community fund");
        
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            _balances[beneficiaries[i]] += amounts[i];
            emit Transfer(address(this), beneficiaries[i], amounts[i]);
        }
        
        communityFund -= totalAmount;
    }
    
    /**
     * @dev Pauses the contract
     */
    function pause() public onlyOwner {
        paused = true;
        emit Paused();
    }
    
    /**
     * @dev Unpauses the contract
     */
    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused();
    }
    
    /**
     * @dev Transfers ownership to a new address
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }
}
