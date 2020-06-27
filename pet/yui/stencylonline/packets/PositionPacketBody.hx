package pet.yui.stencylonline.packets;

import haxe.io.Bytes;

import pet.yui.stencylonline.common.Vector2;

class PositionPacketBody implements IPacketBody {
    public final packetId = PacketId.POSITION;

    public var size(get, never): Int;

    function get_size(): Int
        return Vector2.SIZE;

    public var pos: Vector2;

    public function new(?pos: Vector2) {
        this.pos = pos == null ? Vector2.ZERO : pos;
    }

    public function readFrom(b: Bytes, pos: Int = 0): Int
        return this.pos.readFrom(b, pos);

    public function writeTo(b: Bytes, pos: Int = 0): Int
        return this.pos.writeTo(b, pos);
}

