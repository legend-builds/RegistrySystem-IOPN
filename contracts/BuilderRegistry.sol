// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BuilderRegistry
 * @dev Advanced contract for tracking builder profiles, metrics, and score claims.
 */
contract BuilderRegistry {
    
    struct Builder {
        string githubUsername;
        uint256 points;
        uint256 registeredAt;
        bool isActive;
    }

    address public owner;
    mapping(address => Builder) public builders;
    mapping(string => address) public githubToAddress;
    
    event BuilderRegistered(address indexed builderAddress, string githubUsername);
    event PointsAwarded(address indexed builderAddress, uint256 amount);
    event BuilderDeactivated(address indexed builderAddress);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Register a new builder profile linked to an account or wallet.
     * @param _githubUsername The unique GitHub handle.
     */
    function registerBuilder(string memory _githubUsername) external {
        require(!builders[msg.sender].isActive, "Builder already registered");
        require(bytes(_githubUsername).length > 0, "Invalid GitHub username");

        builders[msg.sender] = Builder({
            githubUsername: _githubUsername,
            points: 100, // Initial bonus points for registering
            registeredAt: block.timestamp,
            isActive: true
        });

        githubToAddress[_githubUsername] = msg.sender;

        emit BuilderRegistered(msg.sender, _githubUsername);
        emit PointsAwarded(msg.sender, 100);
    }

    /**
     * @notice Award score/points to a specific builder.
     * @param _builderAddress The wallet address of the builder.
     * @param _amount The amount of points to add.
     */
    function awardPoints(address _builderAddress, uint256 _amount) external onlyOwner {
        require(builders[_builderAddress].isActive, "Builder not active");
        builders[_builderAddress].points += _amount;

        emit PointsAwarded(_builderAddress, _amount);
    }

    /**
     * @notice Retrieve full details of a registered builder.
     */
    function getBuilderDetails(address _builderAddress) 
        external 
        view 
        returns (string memory githubUsername, uint256 points, uint256 registeredAt, bool isActive) 
    {
        Builder memory b = builders[_builderAddress];
        require(b.isActive, "Builder does not exist");
        return (b.githubUsername, b.points, b.registeredAt, b.isActive);
    }
}
