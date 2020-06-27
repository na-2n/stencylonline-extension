package pet.yui.stencylonline.common;

import haxe.io.Bytes;

interface IHasReadFrom {
    public function readFrom(b: Bytes, pos: Int = 0): Int;
}

