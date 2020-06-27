package pet.yui.stencylonline.common;

import haxe.io.Bytes;

class Vector2 implements IHasBytes
              implements IHasWriteTo
              implements IHasReadFrom {
    public static final ZERO = new Vector2(0, 0);
    public static final ONE = new Vector2(1, 1);

    public static final AXIS_SIZE = 4;
    public static final SIZE = AXIS_SIZE * 2;

    public var x: Float;
    public var y: Float;

    public function new(x: Float = 0, y: Float = 0) {
        this.x = x;
        this.y = y;
    }

    public function readFrom(b: Bytes, pos: Int = 0): Int {
        this.x = b.getFloat(pos);
        this.y = b.getFloat(pos + AXIS_SIZE);

        return pos + SIZE;
    }

    public function writeTo(b: Bytes, pos: Int = 0): Int {
        final space = b.length - pos;

        if (space < SIZE) {
            throw "Buffer does not have enough free space";
        }

        b.setFloat(pos, this.x);
        b.setFloat(pos + AXIS_SIZE, this.y);

        return pos + SIZE;
    }

    public function toBytes(): Bytes {
        final b = Bytes.alloc(SIZE);

        this.writeTo(b);

        return b;
    }

    public static function fromBytes(b: Bytes): Vector2
        return new Vector2(b.getFloat(0), b.getFloat(4));
}

