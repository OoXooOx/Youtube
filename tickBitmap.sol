// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;
pragma abicoder v2;

contract test {

    // ticks can be [−887272,887272]   16,777,215 / 256 = 65,535
    mapping(int24=>bool) public tickValue; 
    // false - we don't have liquidity there
    // true - we have liquidity

    function setTickValue(int24 _tick) external {
        tickValue[_tick]=true;
    }


    mapping(int16 => uint256) public override tickBitmap;
    //78    => 33

    //input -200697
    int24 y = -200697;
    function test2 () public view returns (uint24 x) {
        x=uint24(y); //16.576.519
    } 

    //20001
   
    function position(int24 tick) public pure returns (int16 wordPos, uint8 bitPos) {
        wordPos = int16(tick >> 8);
        bitPos = uint8(tick % 256);
    }

}
