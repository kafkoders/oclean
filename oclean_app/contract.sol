pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

import "./SafeMath.sol";

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
}

/**
 * @title NASA Hackaton
 * @dev Implementation of the constainers system.
 */
contract Containers {
    using SafeMath for uint256;

    event LogNewRobot(uint256 indexed robotId, address robotAddress);
    event LogNewFilling(uint256 indexed robotId, string latitude, string longitude, uint256 timestamp, uint256 catchedWeight);

    struct Container {
        address robotAddress;
        string latitude;
        string longitude;
        uint256 timestamp;
        uint256 catchedWeight;
    }

    mapping (uint256 => address) public containerToOwner;
    mapping (address => uint) ownerContainerCount;

    Container[] private containers;
    IERC20 token;

    constructor(address _tokenAddress) public {
        token = IERC20(_tokenAddress);
    }

    modifier containerExists(uint256 _robotId) {
        require(_robotId < containers.length);
        _;
    }

    modifier robotAddressCheck(uint256 _robotId) {
        require(containers[_robotId].robotAddress == msg.sender);
        _;
    }

    function createContainer(address _robotAddress) public {
        _createContainer(_robotAddress);
    }

    function _createContainer(address _robotAddress) internal {
        uint256 id = containers.push(Container(_robotAddress, "", "", 0, 0)) - 1;
        containerToOwner[id] = msg.sender;
        ownerContainerCount[msg.sender] = ownerContainerCount[msg.sender].add(1);
        emit LogNewRobot(id, _robotAddress);
    }

    function getContainer(uint256 _robotId) public view containerExists(_robotId) returns(address robotAddress, string memory latitude, string memory longitude, uint256 timestamp, uint256 catchedWeight){
        return (containers[_robotId].robotAddress ,containers[_robotId].latitude, containers[_robotId].longitude, containers[_robotId].timestamp, containers[_robotId].catchedWeight);
    }

    function getContainerLenght() external view returns(uint) {
        return containers.length;
    }

    function getAllContainers() public view returns(Container[] memory) {
        return containers;
    }

    //containerExists(0) robotAddressCheck(0)

    function set(string memory _latitude, string memory _longitude, uint256 _timestamp, uint256 _catchedWeight) public {
        containers[0].latitude = _latitude;
        containers[0].longitude = _longitude;
        containers[0].timestamp = _timestamp;
        containers[0].catchedWeight = _catchedWeight;

        emit LogNewFilling(0, _latitude, _longitude, _timestamp, _catchedWeight);
    }
    
    function payForWeight(uint _quantity) public {
        address userToPay = 0xD52A72C80Fd1EC1746Bd020431E14bC30470fD23;
        uint tokensToPay = (_quantity * 10) * 10 ** uint256(18);
        
        /*
        token.approve(address(this), tokensToPay);
        token.transferFrom(address(this), userToPay, tokensToPay);
        */
        token.transfer(userToPay, tokensToPay);
    }
    

    function () external payable {}
}
