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

import floxStuff.Floxing;

import localStorage.SaveOrRetrieve;


import simulation.BasicSimulation;
import simulation.Strategy;
import simulation.Producer;

import simulation.TimeSimulation;
import simulation.Transport;

public class Main extends Sprite {

    private static const SERVER_IP:String = "127.0.0.1";
    private static const SERVER_PORT:uint = 9001;

    private var _id:String = "PlayerName"+String(Math.random()*99999);
    private var _playerType:String = "miner";
    private var _connectionObject:Object = new Object();
    private var _playerCountry:String = "Romania";
    private var _nodeSocket:NodeSocket;

    private var _timer:TimeSimulation = new TimeSimulation();

    private var _resourceGathering:Producer = new Producer("Gatherer", 1000, 2000, 3, 2, 1);
    private var _transporter:Transport = new Transport("Transporter", 500, 1000, 30, 10);
    private var _consumer:Producer = new Producer("Consumer", 400, 200, 10, 7, 1);
    private var _strategy:Strategy = new Strategy();

    private var _facebook:FacebookConnect;
    private var _floxing:Floxing;

    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World Citrus Game";
        addChild(textField);

        // For emulation use directly simulationInit()
        simulationInit();

        // For mobile, use facebook connection
        //_facebook = new FacebookConnect(this.stage, facebookConnected);
        //_facebook.init();
    }

    private function facebookConnected(uid:String):void
    {
        _floxing = new Floxing(uid, floxInited);
        _floxing.init();
    }

    private function floxInited():void
    {
        trace("Flox connected, proceed with server connection");
        simulationInit();
    }

    private function simulationInit():void
    {
        _nodeSocket = new NodeSocket(SERVER_IP, SERVER_PORT, _id, _playerType, _playerCountry);
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
            "workerType":_playerType,
            "country":_playerCountry
        }
        _nodeSocket.writeMessage("", "data", _connectionObject)
    }
}
}
