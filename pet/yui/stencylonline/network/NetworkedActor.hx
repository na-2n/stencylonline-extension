package pet.yui.stencylonline.network;

import pet.yui.stencylonline.common.Vector2;

import com.stencyl.Engine;
import com.stencyl.models.Actor;
import com.stencyl.models.actor.ActorType;

class NetworkedActor {
    var _type: ActorType;
    var _actor: Actor;

    var _layer = 0;

    var _x: Float = 0;
    var _y: Float = 0;

    public var actor(get, never): Actor;
    function get_actor(): Actor
        return this._actor;

    public var x(get, never): Float;
    function get_x(): Float
        return this._x;

    public var y(get, never): Float;
    function get_y(): Float
        return this._y;

    public function new(actorType: ActorType) {
        this._type = actorType;
        this._actor = Engine.engine.createActorOfType(actorType, this._x, this._y, this._layer);
    }

    public function setPosition(pos: Vector2) {
        if (pos.x == this._x && pos.y == this._y) {
            return;
        }

        this._x = pos.x;
        this._y = pos.y;

        this._actor.setLocation(this._x, this._y);
    }
}
