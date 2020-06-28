package pet.yui.stencylonline.packets;

import haxe.io.Bytes;

class Packet implements IPacket {
    public static final MAX_BUFFER_SIZE = 0xFF;

    public var header: PacketHeader;
    public var data: Bytes;

    public var length(get, set): Int;
    function get_length(): Int
        return this.header.length;
    function set_length(length: Int): Int
        return this.header.length = length;

    public var id(get, set): Int;
    function get_id(): Int
        return this.header.packetId;
    function set_id(id: Int): Int
        return this.header.packetId = id;

    public function new(header: PacketHeader, ?data: Bytes) {
        this.header = header;
        this.data = data == null ? Bytes.alloc(MAX_BUFFER_SIZE) : data;
    }

    public static function fromBody(body: IPacketBody): Packet {
        final hdr = new PacketHeader(body.packetId, body.size);
        final pkt = new Packet(hdr);

        body.writeTo(pkt.data);

        return pkt;
    }

    public function toBytes(): Bytes {
        final b = Bytes.alloc(PacketHeader.SIZE_CLIENT + this.length);

        final pos = this.header.writeTo(b);

        b.blit(pos, this.data, 0, this.length);

        return b;
    }
}

