/**
 * Created by adm on 19.09.14.
 */
package objects {
import flash.display.Bitmap;

import games.tinywings.nape.BirdHero;

import nape.geom.Vec2;

import signals.SignalsHub;

import starling.core.Starling;
import starling.display.DisplayObject;

public class BulletCube extends BadCube{
    public function BulletCube(name:String, params:Object = null, hero:BirdHero = null, view:Bitmap = null, signalsManager:SignalsHub = null) {
        super(name, params, hero, view, signalsManager)
    }

    override public function update(timeDelta:Number):void {

        //super.update(timeDelta);

        if (_mouseScope) {
            _hand.anchor1.setxy((_hero.x+500) / Starling.contentScaleFactor, (_hero.y) / Starling.contentScaleFactor);
        }
        if (this.x < _hero.x - 300)
            this.kill = true;
    }

    override public function enableHolding(mouseScope:DisplayObject, offsetX:Number, offsetY:Number, touchX:Number, touchY:Number):void {
        _mouseScope = mouseScope;

        var mp:Vec2 = new Vec2(x, y);

        _hand.anchor2.set(_body.worldPointToLocal(mp, true));
        _hand.active = true;

        _signalsManager.dispatchSignal("showSmallSCore", "showSmallSCore", {target:this});
    }
}
}
