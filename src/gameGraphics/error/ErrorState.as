/**
 * Created by adm on 08.08.14.
 */
package gameGraphics.error {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractState;

import flash.display.BitmapData;

import gameGraphics.AbstractState;

public class ErrorState extends AbstractState implements IAbstractState{
    public function ErrorState(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);
        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800, 480, false, 0x123456)));

        trace("=> ERROR STATE");
    }

    override public function killAll(... rest):void
    {
        super.killAll(rest);
    }
}
}
