/**
 * Created by adm on 08.08.14.
 */
package gameGraphics.game {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractMovie;
import bridge.abstract.IAbstractState;
import bridge.abstract.IAbstractTextField;
import bridge.abstract.ui.IAbstractLabel;

import flash.display.BitmapData;

import gameGraphics.AbstractState;

public class GameState extends AbstractState{

    private var _earningsLabel:IAbstractLabel;
    private var _totalProducedLabel:IAbstractLabel;
    private var _mouse:IAbstractMovie;

    private var _scale:Number = 1;

    public function GameState(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);

        var tTextEarnings:IAbstractTextField = _bridgeGraphics.requestTextField(250, 30, "0", "Verdana", 30);
        _earningsLabel = _bridgeGraphics.requestLabelFromTextfield(tTextEarnings, "earnedLabel");

        var tTextTotalProduced:IAbstractTextField = _bridgeGraphics.requestTextField(250, 30, "0", "Verdana", 30);
        _totalProducedLabel = _bridgeGraphics.requestLabelFromTextfield(tTextTotalProduced, "earnedLabel");

        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800,480,false, 0xFFFFFF)));

        addNewChild(_earningsLabel);

        _totalProducedLabel.y = 40;
        addNewChild(_totalProducedLabel);


        _mouse = _bridgeGraphics.requestMovie("star");
        _mouse.scaleX = _mouse.scaleY = _scale;
        _mouse.x = _mouse.y = 100;
        addNewChild(_mouse);

        trace("=> GAME STATE");
    }

    override public function killAll(...rest):void
    {
        super.killAll(rest);
    }

    public function receivedInformation(timeSpent:Number, obj:Object, produced:Number):void
    {
        trace("-> GAME STATE update info "+obj+" and time spent: "+timeSpent);
        _earningsLabel.updateLabel("$"+String(timeSpent));
        _totalProducedLabel.updateLabel("units "+String(Math.round(produced)));

        _scale = timeSpent;
        _mouse.scaleX = _mouse.scaleY = _scale;
    }
}
}
