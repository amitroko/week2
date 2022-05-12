pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
    // instantiate hasher for each hash that must be computed
    var hasherCount = 0;
    for (var i = 0; i < n; i++) {
        hasherCount += 2 ** i;
    }
    component hashers[hasherCount];
    for (var i = 0; i < hasherCount; i++) {
        hashers[i] = Poseidon(2)
    }

    // hash leaf hashes
    for (var i = 0; i < 2 ** (n - 1); i++) {
        hashers[i].inputs[0] <== leaves[i * 2];
        hashers[i].inputs[1] <== leaves[i * 2 + 1];
    }

    // hash intermediate hashes
    var offset = 0;
    for (var i = 2 ** (n - 1); i < hasherCount; i++) {
        hashers[i].inputs[0] <== hashers[2 * offset].out;
        hashers[i].inputs[1] <== hashers[2 * offset + 1].out;
        offset++;
    }

    root <== hashers[hasherCount - 1].out;
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
    
}