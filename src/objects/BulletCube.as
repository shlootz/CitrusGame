/**
 * Created by adm on 19.09.14.
 */
package objects {
import games.tinywings.nape.BirdHero;

import starling.core.Starling;

public class BulletCube extends BadCube{
    public function BulletCube(name:String, params:Object = null, hero:BirdHero = null) {
        super(name, params, hero)
    }

    override public function update(timeDelta:Number):void {

        //super.update(timeDelta);

        if (_mouseScope) {
            _hand.anchor1.setxy((_hero.x+500) / Starling.contentScaleFactor, (_hero.y) / Starling.contentScaleFactor);
        }
        if (this.x < _hero.x - 300)
            this.kill = true;
    }
}
}
