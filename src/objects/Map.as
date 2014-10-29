/**
 * Created by adm on 02.10.14.
 */
package objects {
import flash.utils.Dictionary;

import starling.display.Quad;

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

    private var _enemiesOnMap:Vector.<Quad> = new Vector.<Quad>();

    public function Map() {
        mapEnemies();
    }

    public function generateEnemy():MappableObject
    {
        update();

        var answer:MappableObject = null;

        if(_mapDictionary[distance] != null)
        {
            answer = _mapDictionary[distance];
        }

        if(_mapDictionary[distance+300] != null)
        {
            showEnemyOnMap()
        }

        return answer;
    }

    private function update():void
    {
        if(_enemiesOnMap.length > 0)
        {
            for(var i:uint = 0; i<_enemiesOnMap.length; i++)
            {
                if(_enemiesOnMap[i].x > 0)
                {
                    _enemiesOnMap[i].x --;
                }
                else
                {
                    removeChild(_enemiesOnMap[i])
                    _enemiesOnMap.shift();
                }
            }
        }
    }

    private function showEnemyOnMap():void
    {
        var enemy:Quad = new Quad(20,20, 0xFF0000, false);
        enemy.x = 800;
        enemy.y = 450;
        addChild(enemy);
        _enemiesOnMap.push(enemy);
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
