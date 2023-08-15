// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../../src/account/WebAuthnAccount.sol";
import "../../src/static/Structs.sol";

contract WebAuthnAccountTest is Test {
    WebAuthnAccount public accountImpl;

    function setUp() public {
        IEntryPoint entryPoint = IEntryPoint(address(0));
        accountImpl = new WebAuthnAccount(entryPoint);
    }

    function testValidateSignatureForAccount_ValidSignature() public {
        bytes32 b = "abc";
        bytes memory signature = abi.encode(
            P256Signature({
                R: 0x9bd9ebe8b6ec5aa98729d8de2a361a79cc21aedc5942385a992a2f1ccfd5e62a,
                S: 0x18efff3a995d00cc55392ed677717de60de87192fde4196545e26e162940b69a
            })
        );

        DevicePublicKey memory pubKey = DevicePublicKey({
            x: 0x1a65071a68a5c7a8b5d1e381c0b0f808e201660d2221cf15f8cdf9a71c97ab66,
            y: 0xb457062eb11298f074d4d63cacd23a796d1e2c45c68007797289189620d9e846
        });

        // Initialize proxy
        WebAuthnAccount proxy = WebAuthnAccount(
            payable(
                new ERC1967Proxy{salt: bytes32(uint256(1))}(
                    address(accountImpl),
                    abi.encodeCall(
                        WebAuthnAccount.initialize,
                        (
                            pubKey,
                            "SyGaYLTddRj5criwRjw8OBNvzg2EewdPIvDBE5fIUwM",
                            address(100)
                        )
                    )
                )
            )
        );

        //
        uint8[501] memory allBytes = [
            74,
            54,
            52,
            99,
            53,
            56,
            50,
            54,
            49,
            49,
            98,
            98,
            55,
            57,
            52,
            55,
            97,
            49,
            53,
            56,
            100,
            100,
            101,
            49,
            100,
            50,
            50,
            49,
            49,
            49,
            99,
            102,
            98,
            98,
            48,
            55,
            51,
            97,
            52,
            54,
            102,
            57,
            51,
            51,
            100,
            55,
            99,
            56,
            100,
            99,
            51,
            54,
            99,
            53,
            100,
            101,
            98,
            101,
            101,
            54,
            97,
            49,
            56,
            102,
            48,
            48,
            53,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            48,
            168,
            55,
            98,
            50,
            50,
            55,
            52,
            55,
            57,
            55,
            48,
            54,
            53,
            50,
            50,
            51,
            97,
            50,
            50,
            55,
            55,
            54,
            53,
            54,
            50,
            54,
            49,
            55,
            53,
            55,
            52,
            54,
            56,
            54,
            101,
            50,
            101,
            54,
            51,
            55,
            50,
            54,
            53,
            54,
            49,
            55,
            52,
            54,
            53,
            50,
            50,
            50,
            99,
            50,
            50,
            54,
            51,
            54,
            56,
            54,
            49,
            54,
            99,
            54,
            99,
            54,
            53,
            54,
            101,
            54,
            55,
            54,
            53,
            50,
            50,
            51,
            97,
            50,
            50,
            52,
            100,
            53,
            52,
            52,
            57,
            55,
            97,
            52,
            101,
            52,
            52,
            53,
            53,
            51,
            50,
            50,
            50,
            50,
            99,
            50,
            50,
            54,
            102,
            55,
            50,
            54,
            57,
            54,
            55,
            54,
            57,
            54,
            101,
            50,
            50,
            51,
            97,
            50,
            50,
            54,
            56,
            55,
            52,
            55,
            52,
            55,
            48,
            55,
            51,
            51,
            97,
            50,
            102,
            50,
            102,
            55,
            55,
            54,
            53,
            54,
            50,
            54,
            49,
            55,
            53,
            55,
            52,
            54,
            56,
            54,
            101,
            50,
            101,
            54,
            55,
            55,
            53,
            54,
            57,
            54,
            52,
            54,
            53,
            50,
            50,
            50,
            99,
            50,
            50,
            54,
            51,
            55,
            50,
            54,
            102,
            55,
            51,
            55,
            51,
            52,
            102,
            55,
            50,
            54,
            57,
            54,
            55,
            54,
            57,
            54,
            101,
            50,
            50,
            51,
            97,
            54,
            54,
            54,
            49,
            54,
            99,
            55,
            51,
            54,
            53,
            50,
            99,
            50,
            50,
            54,
            102,
            55,
            52,
            54,
            56,
            54,
            53,
            55,
            50,
            53,
            102,
            54,
            98,
            54,
            53,
            55,
            57,
            55,
            51,
            53,
            102,
            54,
            51,
            54,
            49,
            54,
            101,
            53,
            102,
            54,
            50,
            54,
            53,
            53,
            102,
            54,
            49,
            54,
            52,
            54,
            52,
            54,
            53,
            54,
            52,
            53,
            102,
            54,
            56,
            54,
            53,
            55,
            50,
            54,
            53,
            50,
            50,
            51,
            97,
            50,
            50,
            54,
            52,
            54,
            102,
            50,
            48,
            54,
            101,
            54,
            102,
            55,
            52,
            50,
            48,
            54,
            51,
            54,
            102,
            54,
            100,
            55,
            48,
            54,
            49,
            55,
            50,
            54,
            53,
            50,
            48,
            54,
            51,
            54,
            99,
            54,
            57,
            54,
            53,
            54,
            101,
            55,
            52,
            52,
            52,
            54,
            49,
            55,
            52,
            54,
            49,
            52,
            97,
            53,
            51,
            52,
            102,
            52,
            101,
            50,
            48,
            54,
            49,
            54,
            55,
            54,
            49,
            54,
            57,
            54,
            101,
            55,
            51,
            55,
            52,
            50,
            48,
            54,
            49,
            50,
            48,
            55,
            52,
            54,
            53,
            54,
            100,
            55,
            48,
            54,
            99,
            54,
            49,
            55,
            52,
            54,
            53,
            50,
            101,
            50,
            48,
            53,
            51,
            54,
            53,
            54,
            53,
            50,
            48,
            54,
            56,
            55,
            52,
            55,
            52,
            55,
            48,
            55,
            51,
            51,
            97,
            50,
            102,
            50,
            102,
            54,
            55,
            54,
            102,
            54,
            102,
            50,
            101,
            54,
            55,
            54,
            99,
            50,
            102,
            55,
            57,
            54,
            49,
            54,
            50,
            53,
            48,
            54,
            53,
            55,
            56,
            50,
            50,
            55,
            100,
            12
        ];

        bytes memory callData = new bytes(allBytes.length);

        for (uint256 i = 0; i < allBytes.length; i++) {
            callData[i] = bytes1(allBytes[i]);
        }

        // bytes memory clientData = allBytes[74 + 1: ];
        // uint256 clientChallengeDataOffset = 12;

        // _copyBytes(
        //     clientData,
        //     clientChallengeDataOffset,
        //     challengeExtracted.length,
        //     challengeExtracted,
        //     0
        // );

        // console.log(challengeEncoded);

        // TODO: Figure this out with tcb, depends on the precomputations
        vm.prank(address(0));
        uint256 res = proxy.validateUserOp(
            UserOperation({
                sender: address(1),
                initCode: "",
                nonce: 1,
                callData: callData,
                callGasLimit: 1,
                verificationGasLimit: 1,
                preVerificationGas: 1,
                maxFeePerGas: 1,
                maxPriorityFeePerGas: 1,
                paymasterAndData: "",
                signature: signature
            }),
            b,
            1
        );

        assertEq(res, 1);
    }
}