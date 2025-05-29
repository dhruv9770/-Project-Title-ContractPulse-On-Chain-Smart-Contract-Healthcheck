// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ContractPulse {
    struct Check {
        string name;
        address target;
        bytes callData;
        uint256 lastCheck;
        bool status; // true = pass, false = fail
    }

    address public admin;
    uint256 public checkCount;
    mapping(uint256 => Check) public checks;

    event CheckAdded(uint256 id, string name, address target);
    event CheckExecuted(uint256 id, bool status, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addCheck(string memory name, address target, bytes memory callData) external onlyAdmin {
        checks[checkCount] = Check(name, target, callData, 0, false);
        emit CheckAdded(checkCount, name, target);
        checkCount++;
    }

    function runCheck(uint256 id) external {
        Check storage check = checks[id];
        (bool success, ) = check.target.call(check.callData);
        check.status = success;
        check.lastCheck = block.timestamp;

        emit CheckExecuted(id, success, block.timestamp);
    }

    function getCheck(uint256 id) external view returns (
        string memory,
        address,
        uint256,
        bool
    ) {
        Check storage c = checks[id];
        return (c.name, c.target, c.lastCheck, c.status);
    }
}
