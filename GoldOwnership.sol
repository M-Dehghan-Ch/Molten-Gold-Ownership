pragma solidity ^0.8.0;

contract GoldOwnership {
    struct Gold {
        address owner;
        uint weight; // Weight of the gold in grams
        bool isMelted;
    }
    
    mapping (uint => Gold) public golds;
    mapping (uint => address[]) public transactions; // Mapping to track ownership transfer history
    uint public goldCount;
    
    event GoldTransferred(uint indexed goldId, address indexed previousOwner, address indexed newOwner);
    
    constructor() {
        goldCount = 0;
    }
    
    function meltGold(address _owner, uint _weight) external returns (uint) {
        require(_weight > 0, "Weight must be greater than zero");
        
        Gold memory newGold = Gold(_owner, _weight, true);
        golds[goldCount] = newGold;
        transactions[goldCount].push(_owner); // Add initial owner to transactions mapping
        emit GoldTransferred(goldCount, address(0), _owner);
        
        goldCount++;
        return goldCount - 1; // Return the ID of the new gold
    }
    
    function transferGold(uint _goldId, address _newOwner) external {
        require(_goldId < goldCount, "Invalid gold ID");
        require(golds[_goldId].isMelted, "Gold is not melted");
        require(golds[_goldId].owner == msg.sender, "Only the current owner can transfer the gold");
        
        golds[_goldId].owner = _newOwner;
        transactions[_goldId].push(_newOwner); // Add new owner to transactions mapping
        emit GoldTransferred(_goldId, msg.sender, _newOwner);
    }
    
    function getTransactionHistory(uint _goldId) external view returns (address[] memory) {
        return transactions[_goldId];
    }
}
