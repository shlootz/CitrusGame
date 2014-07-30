package {

import com.pnwrain.flashsocket.FlashSocket;
import com.pnwrain.flashsocket.events.FlashSocketEvent;

import facebook.FacebookConnect;

import flash.display.Sprite;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.XMLSocket;
import flash.text.TextField;
import com.pnwrain.flashsocket.events.FlashSocketEvent;


import simulation.BasicSimulation;
import simulation.Strategy;
import simulation.Producer;

import simulation.TimeSimulation;
import simulation.Transport;

public class Main extends Sprite {

    private var _id:String = "PlayerName"+String(Math.random()*99999);
    private var _playerType:String = "miner";
    private var _connectionObject:Object = new Object();
    private var _nodeSocket:NodeSocket = new NodeSocket("127.0.0.1", 9001, _id, _playerType);

    private var _timer:TimeSimulation = new TimeSimulation();

    private var _resourceGathering:Producer = new Producer("Gatherer", 1000, 2000, 3, 2, 1);
    private var _transporter:Transport = new Transport("Transporter", 500, 1000, 30, 10);
    private var _consumer:Producer = new Producer("Consumer", 400, 200, 10, 7, 1);
    private var _strategy:Strategy = new Strategy();

    private var _facebook:FacebookConnect;

    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World Citrus Game";
        addChild(textField);

        _facebook = new FacebookConnect();
        addChild(_facebook)
        _facebook.init();
    }

    private function init():void
    {
        _nodeSocket.connect(socketConnected, onDataReceived);

        _strategy.makeNewLinkage(_resourceGathering, _transporter, _consumer);
        _strategy.makeNewLinkage(_resourceGathering, null, _transporter);

        _timer.addListenerToTimer(feedServer);
        _timer.addListenerToTimer(_strategy.step);
        _timer.startTimer();
    }

    private function socketConnected():void
    {
        _nodeSocket.writeMessage("test");
    }

    private function onDataReceived(obj:Object):void
    {
        _resourceGathering.workers = obj["data"]["miners"];
        _transporter.workers = obj["data"]["transporters"];
        _consumer.workers = obj["data"]["producers"];
    }

    private function feedServer():void
    {
        _connectionObject = {
            "produced":_consumer.units,
            "workerType":_playerType
        }
        _nodeSocket.writeMessage("", "data", _connectionObject)
    }
}
}
