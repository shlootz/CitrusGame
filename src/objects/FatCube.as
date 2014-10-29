/**
 * Created by adm on 25.09.14.
 */
package objects {
import flash.display.Bitmap;

import games.tinywings.nape.BirdHero;

import nape.geom.Vec2;

import signals.SignalsHub;

import starling.display.DisplayObject;

public class FatCube extends BadCube{
    public function FatCube(name:String, params:Object = null, hero:BirdHero = null, view:Bitmap = null, signalsManager:SignalsHub = null) {
        super(name, params, hero, view, signalsManager);
        this.cubeLife = 5;
    }

    override public function enableHolding(mouseScope:DisplayObject, offsetX:Number, offsetY:Number, touchX:Number, touchY:Number):void {
        cubeLife --
        if(cubeLife == 0)
        {
            _signalsManager.dispatchSignal("breakObject", "breakObject", {target:this})
        }

        _signalsManager.dispatchSignal("showSmallSCore", "showSmallSCore", {target:this});
    }

    override public function update(timeDelta:Number):void {
        super.update(timeDelta);
        var velocity:Vec2 = _body.velocity;
        velocity.x = 100;
    }
    }
}
