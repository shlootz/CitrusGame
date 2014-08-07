/**
 * Created by adm on 07.08.14.
 */
package gameGraphics {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractSprite;

import starlingEngine.elements.EngineSprite;

public class AbstractGraphics extends EngineSprite implements IAbstractSprite{

    protected var _bridgeGraphics:IBridgeGraphics;

    public function AbstractGraphics(bridgeGraphics:IBridgeGraphics) {
        _bridgeGraphics = bridgeGraphics;
        super ();
    }
}
}
