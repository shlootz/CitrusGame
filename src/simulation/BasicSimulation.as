/**
 * Created by Alex Popescu on 23.07.2014.
 */
package simulation {
public class BasicSimulation {

    protected var _name:String = "";
    protected var _workers:uint = 0;
    protected var _resources:Number = 0;

    public function BasicSimulation(name:String, workers:Number, resoures:Number) {
        _name = name;
        _workers = workers;
        _resources = resoures;
    }

    public function get workers():uint {
        return _workers;
    }

    public function set workers(value:uint):void {
        _workers = value;
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function get resources():Number {
        return _resources;
    }

    public function set resources(value:Number):void {
        _resources = value;
    }
}
}
