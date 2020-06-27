package pet.yui.stencylonline.common;

import haxe.io.Bytes;

interface IHasWriteTo {
    public function writeTo(b: Bytes, pos: Int = 0): Int;
}

