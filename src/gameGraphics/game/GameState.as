/**
 * Created by adm on 08.08.14.
 */
package gameGraphics.game {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractState;

import flash.display.BitmapData;

import gameGraphics.AbstractState;

public class GameState extends AbstractState implements IAbstractState{
    public function GameState(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);
        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800,480,false, 0xEE0000)));

        trace("GAME STATE");
    }

    override public function killAll(... rest):void
    {
        super.killAll(rest);
    }
}
}
