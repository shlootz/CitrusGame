/**
 * Created by adm on 16.09.14.
 */
package objects {
import com.greensock.TweenLite;

import flash.display.Bitmap;

import games.tinywings.nape.BirdHero;

import signals.SignalsHub;

import starling.display.DisplayObject;

import starling.text.TextField;

public class BadCube extends DraggableCube{
    public function BadCube(name:String, params:Object = null, hero:BirdHero = null, view:Bitmap = null, signalsManager:SignalsHub = null) {
        super(name, params, hero, view, signalsManager);
        this.cubeLife = 1;
    }

    public function destroyCube():void
    {
       // TweenLite.to(this.view, .2, {scaleX:0, scaleY:0, onComplete:killCube});
        killCube();
    }

    private function killCube():void
    {
        this.kill = true;
    }

    override public function update(timeDelta:Number):void {

        //super.update(timeDelta);

        if (this.x < _hero.x - 300)
            this.kill = true;
    }

    override public function enableHolding(mouseScope:DisplayObject, offsetX:Number, offsetY:Number, touchX:Number, touchY:Number):void
    {
        super.enableHolding(mouseScope, offsetX, offsetX, touchX, touchY);

        cubeLife --
        if(cubeLife == 0)
        {
            _signalsManager.dispatchSignal("breakObject", "breakObject", {target:this})
        }

        _signalsManager.dispatchSignal("showSmallSCore", "showSmallSCore", {target:this});
    }
}
}
