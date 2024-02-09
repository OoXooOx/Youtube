
interface IPandora {
    function minted() external view returns (uint);
    function safeTransferFrom(address from, address to, uint256 id) external;
    function transfer(address to, uint256 amount) external  returns (bool);
}

//You can buy me coffee 0xDb4CE33fbD72aA160bE47Bc382e53038AD75aFDD
contract pandoraConvert {

    IPandora public constant pandora = IPandora(0x9E9FbDE7C7a83c43913BddC8779158F1368F0413);
    
    //2 iterations - 160 172 gas        66 iterations - 4 381 612 gas             17 iter - 2 701 905 gas
    function convertToRed() external {  
        uint minted = pandora.minted();     
        uint nearestRedId = findRedId(minted); 
        
        while(true) {
            (bool success, bytes memory response) = address(pandora).call(
                abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                msg.sender,
                address(this),
                1 ether)
            );
            require(success && (response.length == 0 || abi.decode(response, (bool))), "Failed send funds");
            unchecked{minted++;}
            if(minted == nearestRedId) {
                pandora.safeTransferFrom(address(this),msg.sender, minted); 
                return;
            }


            (bool success1, bytes memory response1) = address(pandora).call(
                abi.encodeWithSignature(
                "transfer(address,uint256)",
                msg.sender,
                1 ether)
            );
            require(success1 && (response1.length == 0 || abi.decode(response1, (bool))), "Failed send funds");
            unchecked{minted++;}
            if(minted == nearestRedId) break;
        }    
    }

    function findRedId(uint256 id) public pure returns (uint nearestRedId) {
        uint tempTokenId=++id;
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
