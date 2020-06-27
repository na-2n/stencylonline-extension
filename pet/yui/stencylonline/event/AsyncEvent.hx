package pet.yui.stencylonline.event;

import hx.concurrent.executor.Executor;
import hx.concurrent.event.AsyncEventDispatcher;

class AsyncEvent<T> implements IEvent<T> {
    var _executor: Executor;
    var _dispatcher: AsyncEventDispatcher<T>;

    public function new(executor: Executor) {
        this._executor = executor;
        this._dispatcher = new AsyncEventDispatcher<T>(executor);
    }

    public function emit(x: T)
        _dispatcher.fire(x);

    public function on(cb: T -> Void)
        _dispatcher.subscribe(cb);
}

