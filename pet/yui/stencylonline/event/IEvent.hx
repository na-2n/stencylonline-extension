package pet.yui.stencylonline.event;

interface IEvent<T> {
    public function emit(x: T): Void;

    public function on(cb: T -> Void): Void;
}
