package pet.yui.stencylonline;

import sys.thread.Thread;
import sys.net.Socket;
import sys.net.Address;
import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.Error;

import pet.yui.stencylonline.common.IHasBytes;
import pet.yui.stencylonline.common.Vector2;

import pet.yui.stencylonline.packets.Packet;
import pet.yui.stencylonline.packets.PacketId;
import pet.yui.stencylonline.packets.PacketHeader;

import pet.yui.stencylonline.event.IEvent;
import pet.yui.stencylonline.event.AsyncEvent;

import hx.concurrent.Future;
import hx.concurrent.executor.Executor;

class GameClient {
    var _executor: Executor;
    var _packetEvent: IEvent<Packet>;
    var _sock: Socket;
    var _recvTask: Future<Void>;
    var _connected: Bool;

    public var connected(get, never): Bool;
    function get_connected(): Bool
        return _connected;

    public function new(executor: Executor) {
        this._connected = false;
        this._sock = new Socket();

        this._executor = executor;
        this._packetEvent = new AsyncEvent<Packet>(this._executor);
    }

    public function startThread() {
        this._sock.setBlocking(true);

        Thread.create(() -> {
            while (true) {
                this._packetEvent.emit(this.recv());
            }
        });

        /*
        this._sock.setBlocking(false);

        this._recvTask = this._executor.submit(() -> {
            try {
                this._packetEvent.emit(this.recv());
            } catch (e: Error) {}
        }, FIXED_RATE(1));
        */
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

        if (pkt.id == PacketId.JOIN) {
            trace('JOIN: len = ${pkt.length}');
        }

        return pkt;
    }

    public function onPacket(cb: Packet -> Void)
        this._packetEvent.on(cb);

    public function send(d: IHasBytes)
        this._sock.output.write(d.toBytes());
}
