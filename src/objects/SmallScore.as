/**
 * Created by adm on 21.10.14.
 */
package objects {
import citrus.core.CitrusObject;

import starling.display.Sprite;

import starling.text.TextField;

import starlingEngine.elements.EngineSprite;

public class SmallScore extends EngineSprite{

    public var tField:TextField = new TextField(50,30,"1233", "Verdana", 30);

    public function SmallScore(name:String, params:Object = null) {
        super();
    }

    public function show():void
    {
        this.addChild(tField);
    }
}
}
