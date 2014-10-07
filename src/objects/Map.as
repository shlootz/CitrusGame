/**
 * Created by adm on 02.10.14.
 */
package objects {
import flash.utils.Dictionary;

import starling.display.Sprite;

public class Map extends Sprite{

    public static const NO_NEW_ENTITY:String = "no";

    public static const ENEMY_AI_TYPE_1:String = "badCube";
    public static const ENEMY_AI_TYPE_2:String = "bulletCube";
    public static const ENEMY_AI_TYPE_3:String = "fatCube";

    public static const POWERUP_TYPE_1:String = "goodCube";

    public var distance:Number = 0;

    private var _enemyFrequencyStep1:uint = 200;
    private var _mapDictionary:Dictionary = new Dictionary(true);

    public function Map() {
        mapEnemies();
    }

    public function generateEnemy():MappableObject
    {
        var answer:MappableObject = null;

        if(_mapDictionary[distance] != null)
        {
            answer = _mapDictionary[distance];
        }

        return answer;
    }

    public function clearMap():void
    {
        _mapDictionary = new Dictionary(true);
    }

    private function mapEnemies():void
    {
        mapAIEnemies(ENEMY_AI_TYPE_1, 10000, _enemyFrequencyStep1);
        mapAIEnemies(ENEMY_AI_TYPE_2, 10000, 300);
        mapAIEnemies(ENEMY_AI_TYPE_3, 10000, 440);

        mapAIEnemies(POWERUP_TYPE_1, 10000, 250);
        mapHumanEnemies();
    }

    private function mapHumanEnemies():void {

    }

    private function mapAIEnemies(type:String, maxDistance:uint, frequency:uint):void {
        for(var i:uint = 0; i < maxDistance; i+=frequency)
        {
            var mObject:MappableObject = new MappableObject();
            mObject.id = "AIEnnemy@"+i+"-ran"+Math.random()*99999;
            mObject.distanceToAppear = i;
            mObject.type = type;

            _mapDictionary[i] = mObject;
        }
    }
}
}
