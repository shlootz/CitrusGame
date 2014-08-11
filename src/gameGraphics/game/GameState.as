/**
 * Created by adm on 08.08.14.
 */
package gameGraphics.game {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractMovie;
import bridge.abstract.IAbstractState;
import bridge.abstract.IAbstractTextField;
import bridge.abstract.ui.IAbstractLabel;

import citrus.core.CitrusObject;

import citrus.objects.platformer.nape.Platform;

import citrus.physics.nape.Nape;

import flash.display.BitmapData;

import gameGraphics.AbstractState;

import nape.geom.Vec2;

import objects.DraggableCube;

import starling.display.DisplayObject;

import starling.display.Quad;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

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

    override public function initialize():void
    {
        super.initialize();

        var nape:Nape = new Nape("nape");
        nape.visible = true;
        nape.gravity = new Vec2(0, 0);
        add(nape);

        add(new Platform("borderBottom", { x:400, y:600 - 10, width:800, height:10 } ));
        add(new Platform("borderLeft", { x:0, y:300, width:10, height:600 } ));
        add(new Platform("borderRight", { x:800 - 10, y:300, width:10, height:600 } ));
        add(new Platform("borderTop", { x:400 , y:0, width:800, height:10 } ));

        for (var i:uint = 0; i < 300; i++ )
        {
            var w:Number = Math.random() * 50;
            add(new DraggableCube("cube"+i, { view:new Quad(w,w, Math.random()*0xffffff), width:w, height:w, x:Math.random()*800, y:Math.random()*600 } ));
        }
        add(new DraggableCube("cube", { view:new Quad(200,200, Math.random()*0xffffff), width:200, height:200, x:50, y:50} ));
        stage.addEventListener(TouchEvent.TOUCH, _handleTouch);
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

    private function _handleTouch(tEvt:TouchEvent):void
    {

        var art:DisplayObject = (tEvt.target as DisplayObject).parent;

        var touchBegan:Touch = tEvt.getTouch(this, TouchPhase.BEGAN);
        var touchEnded:Touch = tEvt.getTouch(this, TouchPhase.ENDED);

        if (art && (touchBegan || touchEnded)) {

            var object:CitrusObject = (view.getObjectFromArt(art)) as CitrusObject;

            if (object) {

                if (object is DraggableCube) {

                    if (touchBegan)
                        (object as DraggableCube).enableHolding(art);
                    else if (touchEnded)
                        (object as DraggableCube).disableHolding();
                }
            }
        }
    }
}
}
