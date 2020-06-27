package;

import haxe.io.Error;
import haxe.io.Eof;

import pet.yui.stencylonline.GameClient;
import pet.yui.stencylonline.common.Vector2;

import pet.yui.stencylonline.packets.Packet;
import pet.yui.stencylonline.packets.PacketId;
import pet.yui.stencylonline.packets.PositionPacketBody;
import pet.yui.stencylonline.network.NetworkedActor;

import hx.concurrent.executor.Executor;
import hx.concurrent.collection.Queue;
import hx.concurrent.collection.SynchronizedArray;

import com.stencyl.models.actor.ActorType;

class PosUpdate {
    public var pos: Vector2;
    public var id: Int;

    public function new(pos: Vector2, id: Int) {
        this.pos = pos;
        this.id = id;
    }
}

class StencylOnline {
    private static final _executor = Executor.create(4);
    private static final _actors = new SynchronizedArray();

    private static final _posQueue = new Queue<PosUpdate>();

    private static var _x: Float = 0;
    private static var _y: Float = 0;

    public static final client = new GameClient(_executor);
    public static var actorType: Null<ActorType>;
    public static var onConnect = function() {};

    public static function connectSocket(hostname: String, port: Int = 8876) {
        client.connect(hostname, port);
        client.startThread();

        client.onPacket(pkt -> {
            final id = pkt.header.playerId;

            switch (pkt.id) {
                case PacketId.JOIN:
                    trace('player $id joined');

                    if (actorType != null) {
                        _actors[id] = new NetworkedActor(actorType);

                        _actors[id].setPosition(new Vector2(50, 50));
                        //_actorMap[id] = new NetworkedActor(actorType);
                    }

                case PacketId.LEAVE:
                    trace('player $id left');

                    /*
                    if (_actorMap.exists(id)) {
                        _actorMap[id].actor.die();

                        _actorMap.remove(id);
                    }
                    */

                    final actor = _actors.get(id);

                    if (actor != null) {
                        actor.actor.die();

                        _actors.remove(actor);
                    }

                case PacketId.POSITION:
                    if (pkt.length < 9) {
                        trace("invalid packet length for position packet!!");

                        return;
                    }

                    final body = new PositionPacketBody();

                    body.readFrom(pkt.data);

                    _posQueue.push(new PosUpdate(body.pos, id));

                case _: // do nothing
            }
        });

        onConnect();
    }

    public static function update() {
        while (_posQueue.length > 0) {
            final upd = _posQueue.pop();

            final pos = upd.pos;
            final id = upd.id;

            /*
            if (_actorMap.exists(id)) {
                _actorMap[id].setPosition(pos);
            } else {
                trace('actor $id does not exist(?)');
            }
            */

            final actor = _actors.get(id);

            if (actor != null) {
                actor.setPosition(pos);
            }
        }
    }

    public static function sendPos(x: Float, y: Float, force: Bool = false) {
        if (!force && _x == x && _y == y) {
            return;
        }

        _x = x;
        _y = y;

        final body = new PositionPacketBody(new Vector2(x, y));
        final pkt = Packet.fromBody(body);

        client.send(pkt);
    }
}
