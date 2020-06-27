package pet.yui.stencylonline.event;

class SimpleEvent<T> implements IEvent<T> {
    var _subs: List<T -> Void>;

    public function new() {
        this._subs = new List<T -> Void>();
    }

    public function emit(x: T) {
        for (cb in this._subs) {
            cb(x);
        }
    }

    public function on(cb: T -> Void)
        this._subs.add(cb);
}
