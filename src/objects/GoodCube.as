/**
 * Created by adm on 16.09.14.
 */
package objects {
import com.greensock.TweenLite;

import games.tinywings.nape.BirdHero;

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
}
}
