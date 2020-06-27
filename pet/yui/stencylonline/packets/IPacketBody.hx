package pet.yui.stencylonline.packets;

import pet.yui.stencylonline.common.IHasReadFrom;
import pet.yui.stencylonline.common.IHasWriteTo;

interface IPacketBody extends IHasReadFrom
                      extends IHasWriteTo {
    public final packetId: Int;

    public var size(get, never): Int;
}

