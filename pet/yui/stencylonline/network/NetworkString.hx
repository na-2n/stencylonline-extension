package pet.yui.stencylonline.network;

import haxe.io.Bytes;

import pet.yui.stencylonline.common.IHasWriteTo;
import pet.yui.stencylonline.common.IHasReadFrom;

class NetworkString implements IHasWriteTo
                    implements IHasReadFrom {
    var _value: String;

    public var length(get, never): Int;
    function get_length(): Int
        return _value.length;

    public var value(get, never): String;
    function get_value(): String
        return _value;

    public function new(?s: String) {
        this._value = s;
    }

    public function writeTo(b: Bytes, pos: Int = 0): Int {
        b.set(pos++, this.length);

        final strBuf = Bytes.ofString(this.value);

        b.blit(pos++, strBuf, 0, this.length);

        return pos;
    }

    public function readFrom(b: Bytes, pos: Int = 0): Int {
        final len = b.get(pos++);

        this._value = b.getString(pos, len);

        pos += len;

        return pos;
    }

    public static function fromBytes(b: Bytes, pos: Int = 0): NetworkString {
        final str = new NetworkString();

        str.readFrom(b, pos);

        return str;
    }

    public function toString(): String
        return this._value;
}

