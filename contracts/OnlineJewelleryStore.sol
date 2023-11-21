// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OnlineJewelleryStore {
    address public owner;
    
    // Struct to represent a jewellery item
    struct JewelleryItem {
        uint itemId;
        string name;
        uint price;
        address owner;
        bool sold;
    }

    // Mapping to store catalogue of jewellery items
    mapping(uint => JewelleryItem) public catalogue;

    // Mapping to track ownership of each jewellery item
    mapping(uint => address) public ownership;

    // Event emitted when a new item is added to the catalogue
    event ItemAdded(uint itemId, string name, uint price, address owner);

    // Event emitted when an item is purchased
    event ItemPurchased(uint itemId, address buyer);

    // Modifier to ensure that only the owner can perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Modifier to ensure that an item is available for purchase
    modifier itemAvailable(uint itemId) {
        require(catalogue[itemId].itemId != 0, "Item does not exist");
        require(!catalogue[itemId].sold, "Item is already sold");
        _;
    }

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to add a new item to the catalogue
    function addItem(uint itemId, string memory name, uint price) external onlyOwner {
        require(catalogue[itemId].itemId == 0, "Item with this ID already exists");

        catalogue[itemId] = JewelleryItem({
            itemId: itemId,
            name: name,
            price: price,
            owner: address(0),
            sold: false
        });

        emit ItemAdded(itemId, name, price, address(0));
    }

    // Function to purchase a jewellery item
    function purchaseItem(uint itemId) external payable itemAvailable(itemId) {
        require(msg.value >= catalogue[itemId].price, "Insufficient funds");

        // Mark the item as sold
        catalogue[itemId].sold = true;

        // Transfer ownership and funds
        ownership[itemId] = msg.sender;
        catalogue[itemId].owner = msg.sender;

        // Emit the purchase event
        emit ItemPurchased(itemId, msg.sender);
    }

    // Function to get the details of a jewellery item
    function getItemDetails(uint itemId) external view returns (uint, string memory, uint, address, bool) {
        return (
            catalogue[itemId].itemId,
            catalogue[itemId].name,
            catalogue[itemId].price,
            catalogue[itemId].owner,
            catalogue[itemId].sold
        );
    }
}
