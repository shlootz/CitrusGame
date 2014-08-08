/**
 * Created by adm on 07.08.14.
 */
package gameGraphics {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractState;

import starlingEngine.elements.EngineState;

public class AbstractState extends EngineState implements IAbstractState{

    protected var _bridgeGraphics:IBridgeGraphics;

    public function AbstractState(bridgeGraphics:IBridgeGraphics) {
        _bridgeGraphics = bridgeGraphics;
        super();
    }
}
}
