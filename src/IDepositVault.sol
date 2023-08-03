// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {ERC1363Receiver} from "./IERC1363Receiver.sol";
import {ERC1363Spender} from "./IERC1363Spender.sol";

// We split the errors and events out into separate interfaces so we can test them.

interface IDepositVaultEvents {
    event Deposit(uint256 indexed userId, address indexed token, uint256 amount);
    event NativeDeposit(uint256 indexed userId, uint256 amount);
    event Sweep(address indexed token, address indexed toTreasury);
    event NativeSweep(address indexed toTreasury);
    event TrustedForwarderUpdated(address forwarder);
    event ControllerUpdated(address controller);
}

interface IDepositVaultErrors {
    error InitError();
    error AuthorizationError();
    error TransferError();
}

interface IDepositVault is
    IDepositVaultEvents,
    IDepositVaultErrors,
    ERC1363Receiver,
    ERC1363Spender
{
    function init(address _controller, address _newTrustedForwarder) external;

    function isInit() external returns (bool);

    function controller() external returns (address);

    function setController(address _controller) external;

    function trustedForwarder() external returns (address);

    function setTrustedForwarder(address _newTrustedForwarder) external;

    function isTrustedForwarder(address forwarder) external returns (bool);

    function deposit(uint256 _userId, IERC20 _token, uint256 _amount) external;

    function depositNative(uint256 _userId) external payable;

    function sweep(IERC20 _token, address _toTreasury) external;

    function sweepNative(address payable _toTreasury) external;

    function getDeposit(address _token, uint256 _userId) external returns (uint256);

    function getNativeDeposit(uint256 _userId) external returns (uint256);

    function doAnything(
        address _target,
        bytes memory _data
    ) external payable returns (bytes memory);

    function onTransferReceived(address, address, uint256, bytes memory) external returns (bytes4);

    function onApprovalReceived(address, uint256, bytes memory) external returns (bytes4);
}
