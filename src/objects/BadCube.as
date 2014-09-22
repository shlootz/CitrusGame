/**
 * Created by adm on 16.09.14.
 */
package objects {
import com.greensock.TweenLite;

import games.tinywings.nape.BirdHero;
import games.tinywings.nape.TouchInput;

import starling.text.TextField;

public class BadCube extends DraggableCube{
    public function BadCube(name:String, params:Object = null, hero:BirdHero = null, touchInput:TouchInput = null) {
        super(name, params, hero, touchInput);
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
}
}
