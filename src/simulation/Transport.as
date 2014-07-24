/**
 * Created by Alex Popescu on 22.07.2014.
 */
package simulation {
public class Transport extends BasicSimulation
{
    private var _costPerLoad:Number = 0;
    private var _volumePerTransport:Number = 0;

    public function Transport(name:String, workers:Number, resources:Number, costPerLoad:Number, volumePerTransport:Number) {
        super (name, workers, resources);
        _costPerLoad = costPerLoad;
        _volumePerTransport = volumePerTransport;
    }

    public function doTransport(from:Producer, to:Producer):void
    {
        var maxLoad:Number = _workers * _volumePerTransport;
        var actualLoad:Number = 0;

        var maxCost:Number = maxLoad * _costPerLoad;
        var actualCost:Number = 0;

        if(maxLoad <= from.units)
        {
            actualLoad = maxLoad;
        }
        else
        {
            actualLoad = from.units;
        }

        if(actualLoad * _costPerLoad > _resources)
        {
            actualLoad = _resources / _costPerLoad;
        }

        to.resources += actualLoad;
        from.resources -= actualLoad;
        _resources -= actualLoad * _costPerLoad;

    }

    public function get costPerLoad():Number {
        return _costPerLoad;
    }

    public function set costPerTransport(value:Number):void {
        _costPerLoad = value;
    }

    public function get volumePerTransport():Number {
        return _volumePerTransport;
    }

    public function set volumePerTransport(value:Number):void {
        _volumePerTransport = value;
    }
}
}
