/**
 * Created by adm on 16.09.14.
 */
package objects {
import com.greensock.TweenLite;

import games.tinywings.nape.BirdHero;

import starling.core.Starling;

public class GoodCube extends DraggableCube{
    public function GoodCube(name:String, params:Object = null, hero:BirdHero = null) {
        super (name, params, hero);
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
}
}
