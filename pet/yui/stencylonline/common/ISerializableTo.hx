package pet.yui.stencylonline.common;

import haxe.io.Bytes;

interface ISerializableTo {
    public function serializeTo(b: Bytes, pos: Int = 0): Void;
}

