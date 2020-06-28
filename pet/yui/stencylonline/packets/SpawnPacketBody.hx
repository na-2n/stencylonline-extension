package pet.yui.stencylonline.packets;

import haxe.io.Bytes;

import pet.yui.stencylonline.common.Vector2;
import pet.yui.stencylonline.network.NetworkString;

class SpawnPacketBody implements IPacketBody {
    public final packetId = PacketId.SPAWN;

    var _objectType: NetworkString;

    public var objectPos: Vector2;

    public var objectType(get, set): String;
    function get_objectType(): String
        return this._objectType.value;
    function set_objectType(str: String): String {
        this._objectType = new NetworkString(str);

        return this._objectType.value;
    }

    public var size(get, never): Int;
    function get_size(): Int
        return Vector2.SIZE + 1 + this._objectType.length;

    public function new(?pos: Vector2, ?type: String) {
        this.objectPos = pos == null ? Vector2.ZERO : pos;
        this.objectType = type == null ? "" : type;
    }

    public function writeTo(b: Bytes, pos: Int = 0): Int {
        this.objectPos.writeTo(b, pos);
        pos += Vector2.SIZE;

        this._objectType.writeTo(b, pos);
        pos += this.objectType.length;

        return pos;
    }

    public function readFrom(b: Bytes, pos: Int = 0): Int {
        this.objectPos.readFrom(b, pos);
        pos += Vector2.SIZE;

        this._objectType.readFrom(b, pos);
        pos += this.objectType.length;

        return pos;
    }
}

