package pet.yui.stencylonline;

import sys.net.Socket;
import sys.net.Address;
import sys.net.Host;

import pet.yui.stencylonline.common.IHasBytes;
import pet.yui.stencylonline.packets.Packet;
import pet.yui.stencylonline.packets.PacketHeader;

class GameClient {
    var _sock: Socket;
    var _connected: Bool;

    public var connected(get, never): Bool;
    function get_connected(): Bool
        return _connected;

    public function new() {
        this._connected = false;
        this._sock = new Socket();

        this._sock.setBlocking(false);
    }

    public function connect(hostname: String, port: Int) {
        var host = new Host(hostname);

        this._sock.connect(host, port);

        this._connected = true;
    }

    public function recv(): Packet {
        final hdr = PacketHeader.fromInput(this._sock.input);
        final data = this._sock.input.read(hdr.length);
        final pkt = new Packet(hdr, data);

        return pkt;
    }

    public function send(d: IHasBytes)
        this._sock.output.write(d.toBytes());
}
