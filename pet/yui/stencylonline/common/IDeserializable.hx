package pet.yui.stencylonline.common;

import haxe.io.Bytes;

interface IDeserializable {
    public function deserialize(b: Bytes, pos: Int = 0): Void;
}
