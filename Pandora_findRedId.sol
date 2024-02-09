contract sample {

    function findRedId(uint256 id) public pure returns (uint nearestRedId) {
        uint tempTokenId=id;
        while(true) {
            uint8 seed = uint8(bytes1(keccak256(abi.encodePacked(tempTokenId))));

            if(seed>240 && seed <= 255) {
                nearestRedId=tempTokenId;
                break;
            }
            tempTokenId++;
        }
    }
}
