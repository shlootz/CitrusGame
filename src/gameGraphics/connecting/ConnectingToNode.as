/**
 * Created by adm on 08.08.14.
 */
package gameGraphics.connecting {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractState;

import flash.display.BitmapData;

import gameGraphics.AbstractState;

public class ConnectingToNode extends AbstractState implements IAbstractState{
    public function ConnectingToNode(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);
        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800,480,false, 0xCCCC00)));
        trace("=> CONNECTING TO NODE");
    }

    override public function killAll(...rest):void
    {
        super.killAll(rest);
    }
}
}
