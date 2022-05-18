//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        hashes = new uint[](15);
        for (uint i = 0; i < 8; i++) {
            hashes[i] = 0;
        }

        uint x = 0;
        for (uint i = 8; i < 15; i++) {
            hashes[i] = PoseidonT3.poseidon([hashes[x * 2], hashes[x * 2 + 1]]);
            x++;
        }

        root = hashes[14];
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        hashes[index] = hashedLeaf;

        uint x = 0;
        for (uint i = 8; i < 15; i++) {
            hashes[i] = PoseidonT3.poseidon([hashes[x * 2], hashes[x * 2 + 1]]);
            x++;
        }

        root = hashes[14];
        index += 1;
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        bool proofValid = verifyProof(a, b, c, input);
        bool inputIsRoot = input[0] == root;
        return proofValid && inputIsRoot;
    }
}
