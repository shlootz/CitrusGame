/**
 * Created by adm on 29.07.14.
 */
package simulation {
import flash.events.TimerEvent;
import flash.utils.Timer;

public class TimeSimulation {

    private var _myTimer:Timer;
    private var _listeners:Vector.<Function> = new Vector.<Function>();

    public function TimeSimulation() {
        _myTimer = new Timer(1000, int.MAX_VALUE);
        _myTimer.addEventListener(TimerEvent.TIMER, tick)
    }

    private function tick(event:TimerEvent):void {
        var i:uint;
        for(i = 0; i<_listeners.length; i++)
        {
            _listeners[i].call();
        }
    }

    public function startTimer():void
    {
        _myTimer.start();
    }

    public function stopTimer():void
    {
        _myTimer.stop()
    }

    public function get currentTime():Number
    {
        return _myTimer.currentCount;
    }

    public function addListenerToTimer(f:Function):void
    {
        _listeners.push(f);
    }
}
}
