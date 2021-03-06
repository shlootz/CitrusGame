/**
 * Created by adm on 07.08.14.
 */
package gameGraphics.preloader {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractState;

import flash.display.BitmapData;

import gameGraphics.AbstractState;

import starlingEngine.elements.EngineState;

public class PreloaderState extends AbstractState implements IAbstractState
{
    private var _preloader:Preloader;

    public function PreloaderState(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);
        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800,480,false, 0xFF0000)));

        trace("=> PRELOADER STATE");
    }

    override public function killAll(... rest):void
    {
        super.killAll(rest);
    }

}
}
