package pet.yui.stencylonline.packets;

import haxe.io.Bytes;
import haxe.io.Input;

import pet.yui.stencylonline.common.IHasWriteTo;

class PacketHeader implements IHasWriteTo {
    public static final SIZE_CLIENT = 2;
    public static final SIZE_SERVER = 3;

    var _playerId: Int;

    public var length: Int;
    public var packetId: Int;

    public var playerId(get, never): Int;

    function get_playerId(): Int
        return this._playerId;

    public function new(length: Int = 0, id: Int = 0) {
        this.length = length;
        this.packetId = id;
    }

    public static function fromInput(input: Input): PacketHeader {
        final hdr = new PacketHeader();

        hdr.length = input.readByte();
        hdr.packetId = input.readByte();
        hdr._playerId = input.readByte();

        return hdr;
    }

    public static function fromBytes(b: Bytes, pos: Int = 0): PacketHeader {
        final hdr = new PacketHeader();

        hdr.length = b.get(pos++);
        hdr.packetId = b.get(pos++);
        hdr._playerId = b.get(pos);

        return hdr;
    }

    public function writeTo(b: Bytes, pos: Int = 0): Int {
        b.set(pos++, this.length);
        b.set(pos++, this.packetId);

        return pos;
    }
}

