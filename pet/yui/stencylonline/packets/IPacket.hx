package pet.yui.stencylonline.packets;

import pet.yui.stencylonline.common.IHasBytes;

interface IPacket extends IHasBytes {
    public var id(get, set): Int;
    public var length(get, set): Int;
}

