/**
 * Created by adm on 08.08.14.
 */
package gameGraphics.loginMenu {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractState;

import flash.display.BitmapData;

import gameGraphics.AbstractState;

public class LoginState extends AbstractState implements IAbstractState{
    public function LoginState(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);
        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800, 480, false, 0x000000)));

        trace("=> LOGIN STATE");
    }

    override public function killAll(... rest):void
    {
        super.killAll(rest);
    }
}
}
