/**
 * Created by adm on 16.09.14.
 */
package objects {
import com.greensock.TweenLite;
import com.pzuh.utils.Basic;

import flash.display.Bitmap;

import games.tinywings.nape.BirdHero;

import nape.geom.Vec2;

import signals.SignalsHub;

import starling.core.Starling;
import starling.display.DisplayObject;

public class GoodCube extends DraggableCube{
    public function GoodCube(name:String, params:Object = null, hero:BirdHero = null, view:Bitmap = null, signalsManager:SignalsHub = null) {
        super (name, params, hero, view, signalsManager);
    }

    public function destroyCube():void
    {
        TweenLite.to(this.view, .2, {scaleX:0, scaleY:0, onComplete:killCube});
    }

    private function killCube():void
    {
        this.kill = true;
    }

    override public function update(timeDelta:Number):void {

        //super.update(timeDelta);

        if (_mouseScope) {
            _hand.anchor1.setxy((_hero.x) / Starling.contentScaleFactor, (_hero.y) / Starling.contentScaleFactor);
        }
        if (this.x < _hero.x - 300)
            this.kill = true;
    }

    override public function enableHolding(mouseScope:DisplayObject, offsetX:Number, offsetY:Number, touchX:Number, touchY:Number):void {

        _mouseScope = mouseScope;

        var angle:Number = Basic.getPointAngle(_hero.x, _hero.y, x, y);

        //var angle:Number = rotation;

        rotation = Basic.radianToDegree(angle);

        var xDir:Number = Math.cos(angle) * 20000;
        var yDir:Number = Math.sin(angle) * 20000;

        this.body.applyImpulse(new Vec2(xDir, yDir));

        grabbed = true;
    }

    }
}
