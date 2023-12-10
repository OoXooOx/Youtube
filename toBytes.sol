
// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;
contract sample {

    function toPool(bytes calldata _bytes) public pure returns (address token0, uint24 fee, address token1) {
        assembly {
            let firstWord := calldataload(_bytes.offset)
            token0 := shr(96, firstWord)
            fee := and(shr(72, firstWord), 0xffffff)
            token1 := shr(96, calldataload(add(_bytes.offset, 23)))
        }
    }


    function toLengthOffset2(bytes calldata _bytes, uint256 _arg) public pure returns (uint256 offset, bytes memory _calldata) {
        assembly {
            offset := _bytes.offset // 100
            
        }
        return (offset, msg.data);
        //Calldata:
        //0xde2fe417 4 selector
        //0000000000000000000000000000000000000000000000000000000000000040 // 32
        //0000000000000000000000000000000000000000000000000000000000000006 //64
        //0000000000000000000000000000000000000000000000000000000000000160 // in dec 352 length   
        //00000000000000000000000004fb784d1be2b8e7079d34df3addd8bfcc2f0ccf // offset 100
        //000000000000000000000000000000000000000000004c88031c70f8329886ff
        //000000000000000000000000000000000000000000000000000000006542105d
        //0000000000000000000000000000000000000000000000000000000000000009
        //000000000000000000000000ef1c6e67703c7bd7107eed8303fbe6ec2554bf6b
        //000000000000000000000000000000000000000000000000000000006542105d
        //00000000000000000000000000000000000000000000000000000000000000e0
        //0000000000000000000000000000000000000000000000000000000000000041
        //284b9995f4ea5f891ffc83c2de04c6df5c4e1f1d0a058f6ac19854116a81df9c2a3cc1d05e13557f6ed8ae4856aeb9094c904114c64476ea905f9a04fe00af6a1c00000000000000000000000000000000000000000000000000000000000000

        //de2fe417000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000160 - 100 bytes
        //result offset 100

    }

    function shl (uint256 _arg) pure public returns (uint x) {
        assembly{
            x := shl(5, _arg)  // just _arg*32 // 30107500965189632
            //input - 6
            // result - 192
            // 110     - 6 in binary
            //So, shl(5, _arg) means that you are taking the binary representation of _arg and shifting its bits 5 positions to the left, effectively multiplying it by 2^5
            // shifting it left by 5 positions results in 11000000, which is 192 in decimal. So, in this case, it is indeed equivalent to _arg * 32.
        }
    } // 577 gas


    function shl1(uint256 _arg) pure public returns (uint x) {

        x=_arg*32;

    } //819 gas We have IsZero check here



    function calldataload (bytes calldata _bytes, uint256 _arg) pure public returns (uint x) {
         assembly {
            x := calldataload(add(_bytes.offset, shl(5, _arg))) // load from 100+192 = (292 -4)/32
           
           //result - 224
        }
    }



    function toLengthOffset(bytes calldata _bytes, uint256 _arg) public pure returns (uint256 lengthPtr, uint256 length, uint256 offset) {
        uint256 relativeOffset;
        assembly {
            lengthPtr := add(_bytes.offset, calldataload(add(_bytes.offset, shl(5, _arg)))) // 100 +   224 = 324
                              //100              //            100         +       192   = 292
            length := calldataload(lengthPtr) // calldataload(324)   65
            offset := add(lengthPtr, 0x20) //324+32 = 356  for pure signature (we must cut length of it)
            relativeOffset := sub(offset, _bytes.offset) // 356-100 = 256 
            

                //result   
                // uint256: lengthPtr 324
                // 1:
                // uint256: length 65
                // 2:
                // uint256: offset 356
        }
        //352<65+256 352<321
        if (_bytes.length < length + relativeOffset) revert();

   

    }
        //00000000000000000000000004fb784d1be2b8e7079d34df3addd8bfcc2f0ccf000000000000000000000000000000000000000000004c88031c70f8329886ff000000000000000000000000000000000000000000000000000000006542105d0000000000000000000000000000000000000000000000000000000000000009000000000000000000000000ef1c6e67703c7bd7107eed8303fbe6ec2554bf6b000000000000000000000000000000000000000000000000000000006542105d00000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000041284b9995f4ea5f891ffc83c2de04c6df5c4e1f1d0a058f6ac19854116a81df9c2a3cc1d05e13557f6ed8ae4856aeb9094c904114c64476ea905f9a04fe00af6a1c00000000000000000000000000000000000000000000000000000000000000
    //04fb784d1be2b8e7079d34df3addd8bfcc2f0ccf002710c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2



    function toBytes(bytes calldata _bytes, uint256 _arg) public pure returns (bytes calldata res) {
        (uint256 lengthPtr, uint256 length, uint256 offset) = toLengthOffset(_bytes, _arg); //65 356
        assembly {
            res.length := length
            res.offset := offset
        }
        // input - 00000000000000000000000004fb784d1be2b8e7079d34df3addd8bfcc2f0ccf000000000000000000000000000000000000000000004c88031c70f8329886ff000000000000000000000000000000000000000000000000000000006542105d0000000000000000000000000000000000000000000000000000000000000009000000000000000000000000ef1c6e67703c7bd7107eed8303fbe6ec2554bf6b000000000000000000000000000000000000000000000000000000006542105d00000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000041284b9995f4ea5f891ffc83c2de04c6df5c4e1f1d0a058f6ac19854116a81df9c2a3cc1d05e13557f6ed8ae4856aeb9094c904114c64476ea905f9a04fe00af6a1c00000000000000000000000000000000000000000000000000000000000000
        //  input - 6 
        //res 0x284b9995f4ea5f891ffc83c2de04c6df5c4e1f1d0a058f6ac19854116a81df9c2a3cc1d05e13557f6ed8ae4856aeb9094c904114c64476ea905f9a04fe00af6a1c
    }


    function tst (bytes calldata _inputs) public pure returns (bytes calldata  data) {
        
        data = toBytes(_inputs, 6);
    } 
}
