/**
 * Created by Alex Popescu on 07.08.14.
 */
package gameGraphics.preloader {
import bridge.IBridgeGraphics;

import flash.display.BitmapData;

import gameGraphics.AbstractGraphics;

public class Preloader extends AbstractGraphics
{
    public function Preloader(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);

        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800,480,true, 0xFF0000)));
    }
}
}
