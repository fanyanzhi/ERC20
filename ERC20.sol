// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

interface IERC20 {
    function totalSupply() external view returns(uint256);

    function balanceOf(address account) external view returns(uint256);

    function transfer(address recipient, uint256 amount) external returns(bool);

    function allowance(address owner, address spender) external view returns(uint256);

    function approve(address spender, uint256 amount) external returns(bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);
}

contract ERC20 is IERC20{
    uint public totalSupply;  //token总的发行数量

    mapping(address => uint) public balanceOf;

    //owner允许spender花费owner的多少token
    mapping(address => mapping(address => uint)) public allowance;

    //元数据
    string public name = "Test";
    string public symbol = "Test";
    uint8 public decimals = 18;  

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    //将msg.sender调用方地址中的token打给recipient
    function transfer(address recipient, uint256 amount) external returns(bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    //调用方msg.sender允许spender花费多少token
    function approve(address spender, uint256 amount) external returns(bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    //可以通过任意一方来调用，把sender的token打给recipient；前提是sender允许目前的调用方msg.sender有这么个额度
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //发行
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }
    
    //销毁
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}