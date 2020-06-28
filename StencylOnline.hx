package;

import haxe.io.Error;

import pet.yui.stencylonline.GameClient;
import pet.yui.stencylonline.common.Vector2;
import pet.yui.stencylonline.packets.Packet;
import pet.yui.stencylonline.packets.PacketId;
import pet.yui.stencylonline.packets.SpawnPacketBody;
import pet.yui.stencylonline.packets.PositionPacketBody;
import pet.yui.stencylonline.network.NetworkedActor;

import com.stencyl.models.Actor;
import com.stencyl.models.actor.ActorType;

typedef SpawnRequest = String->Actor->Float->Float -> Void;

class StencylOnline {
    static final _actors = new Map<Int, NetworkedActor>();

    static var _x: Float = 0;
    static var _y: Float = 0;

    public static final client = new GameClient();
    public static var actorType: Null<ActorType>;

    public static var onSpawnRequest: SpawnRequest = (objectType: String, actor: Actor, x: Float, y: Float) -> {};
    public static var onConnect = () -> {};

    public static function connectSocket(hostname: String, port: Int = 8876) {
        client.connect(hostname, port);

        onConnect();
    }

    static function _onPacket(pkt: Packet) {
        final id = pkt.header.playerId;

        switch (pkt.id) {
            case PacketId.JOIN:
                trace('player $id joined');

                if (actorType != null) {
                    _actors[id] = new NetworkedActor(actorType);

                    _actors[id].setPosition(new Vector2(50, 50));
                }

            case PacketId.LEAVE:
                trace('player $id left');

                if (_actors.exists(id)) {
                    final actor = _actors[id];

                    actor.actor.die();

                    _actors.remove(id);
                }

            case PacketId.POSITION:
                final body = new PositionPacketBody();

                body.readFrom(pkt.data);

                if (_actors.exists(id)) {
                    final actor = _actors[id];

                    actor.setPosition(body.pos);
                }

            case PacketId.SPAWN:
                final body = new SpawnPacketBody();

                body.readFrom(pkt.data);

                if (_actors.exists(id)) {
                    final actor = _actors[id];

                    onSpawnRequest(body.objectType, actor.actor, body.objectPos.x, body.objectPos.y);
                }

            case _: // do nothing
        }
    }

    public static function update() {
        try {
            final pkt = client.recv();

            _onPacket(pkt);
        } catch (e: Error) {}
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

    public static function sendSpawn(x: Float, y: Float, str: String) {
        final body = new SpawnPacketBody(new Vector2(x, y), str);
        final pkt = Packet.fromBody(body);

        client.send(pkt);
    }
}
