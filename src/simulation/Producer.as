/**
 * Created by Alex Popescu on 22.07.2014.
 */
package simulation {
public class Producer extends  BasicSimulation
{

    private var _unitsPerWorker:Number;

    private var _units:Number;

    private var _unitCost:Number;

    private var _pending:Boolean = false;

    public function Producer(name:String, workers:Number, resources:Number, unitesPerWorker:Number,unitCost:Number, units:Number = 0) {
        super(name, workers, resources);
        _unitsPerWorker = unitsPerWorker;
        _units = units;
        _unitCost = unitCost;
    }

    public function produce():void
    {
        var newUnits:Number = _workers*_unitsPerWorker;
        var estimateCost:Number = newUnits * _unitCost;

        if(estimateCost < resources) {
            _units += newUnits;
            _resources -= estimateCost;
        }
        else
        {
            newUnits = _resources / _unitCost;
            _units += newUnits;
            _resources -= newUnits * _unitCost;
        }
    }

    public function get units():Number {
        return _units;
    }

    public function set units(value:Number):void {
        _units = value;
    }

    public function get unitsPerWorker():Number {
        return _unitsPerWorker;
    }

    public function set unitsPerWorker(value:Number):void {
        _unitsPerWorker = value;
    }

    public function get unitCost():Number {
        return _unitCost;
    }

    public function set unitCost(value:Number):void {
        _unitCost = value;
    }

    public function get pending():Boolean {
        return _pending;
    }

    public function set pending(value:Boolean):void {
        _pending = value;
    }
}
}
