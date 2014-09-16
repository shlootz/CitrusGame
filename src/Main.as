package {

import bridge.BridgeGraphics;
import bridge.IBridgeGraphics;
import bridge.abstract.AbstractPool;
import bridge.abstract.IAbstractDisplayObject;
import bridge.abstract.IAbstractState;
import bridge.abstract.transitions.IAbstractStateTransition;
import bridge.abstract.ui.IAbstractButton;

import com.greensock.TweenLite;
import com.greensock.easing.Cubic;

import com.pnwrain.flashsocket.FlashSocket;
import com.pnwrain.flashsocket.events.FlashSocketEvent;

import facebook.FacebookConnect;

import flash.display.BitmapData;

import flash.display.DisplayObject;

import flash.display.Sprite;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Point;
import flash.net.XMLSocket;
import flash.text.TextField;
import com.pnwrain.flashsocket.events.FlashSocketEvent;

import floxStuff.Floxing;

import gameGraphics.connecting.ConnectingToNode;
import gameGraphics.error.ErrorState;
import gameGraphics.game.GameState;

import gameGraphics.loginMenu.LoginState;

import gameGraphics.preloader.Preloader;
import gameGraphics.preloader.PreloaderState;

import games.braid.BraidDemo;
import games.hungryhero.com.hsharma.hungryHero.screens.InGame;
import games.osmos.OsmosGameState;
import games.tinywings.nape.TinyWingsGameState;

import localStorage.SaveOrRetrieve;

import nape.space.Space;

import signals.ISignalsHub;
import signals.Signals;

import signals.SignalsHub;


import simulation.BasicSimulation;
import simulation.Strategy;
import simulation.Producer;

import simulation.TimeSimulation;
import simulation.Transport;

import starling.animation.Juggler;

import starling.utils.AssetManager;

import starlingEngine.StarlingEngine;
import starlingEngine.transitions.EngineStateTransition;

[SWF(backgroundColor='#ffffff',frameRate='60')]

public class Main extends Sprite {

    //CONNECTION DETAILS
    private static const SERVER_IP:String = "127.0.0.1";
    private static const SERVER_PORT:uint = 9001;

    //SOCIAL
    private var _facebook:FacebookConnect;

    //BACKEND
    private var _floxing:Floxing;

    //PLAYER DETAILS
    //TO DO - _id must cbe the facebook id
    private var _id:String = "PlayerName"+String(Math.random()*99999);
    private var _playerType:String = "producer";
    private var _connectionObject:Object = new Object();
    private var _playerCountry:String = "Romania";
    private var _nodeSocket:NodeSocket;

    //GAME SIMULATION STEP
    private var _timer:TimeSimulation = new TimeSimulation();

    //GAME TYPES
    private var _resourceGathering:Producer = new Producer("Gatherer", 0, 2000, 3, 2, 1);
    private var _transporter:Transport = new Transport("Transporter", 0, 1000, 30, 10);
    private var _consumer:Producer = new Producer("Consumer", 0, 200, 10, 7, 1);
    private var _strategy:Strategy = new Strategy();

    //GRAPHICS
    private var _canvasSize:Point = new Point(800, 480);
    private var _bridgeGraphics:IBridgeGraphics = new BridgeGraphics(_canvasSize, StarlingEngine,
            starling.utils.AssetManager,
            signals.SignalsHub,
            AbstractPool,
            starling.animation.Juggler,
            nape.space.Space,
            true);

    private var _stateTransition:IAbstractStateTransition;

    private var _loadingState:IAbstractState;
    private var _loginState:IAbstractState;
    private var _connectingToServerState:IAbstractState;
    private var _gameState:GameState;
    private var _errorState:IAbstractState;

    public function Main() {
        initGraphics();
    }

    private function initBraid():void
    {
        //_bridgeGraphics.tranzitionToState(new BraidDemo() as IAbstractState);
        //_bridgeGraphics.tranzitionToState(new InGame() as IAbstractState);
        _bridgeGraphics.tranzitionToState(new TinyWingsGameState() as IAbstractState);
    }

    private function initGraphics():void{
        addChild(_bridgeGraphics.engine as DisplayObject);
        (_bridgeGraphics.signalsManager as ISignalsHub).addListenerToSignal(Signals.STARLING_READY, loadAssets);
    }

    private function loadAssets(event:String, obj:Object):void {

        (_bridgeGraphics.assetsManager).enqueue("assets/ui.png", "assets/ui.xml", "assets/layouts/testLayout.xml", "assets/layouts/hamster.png", "assets/layouts/hamster.xml");

        (_bridgeGraphics.assetsManager).loadQueue(function(ratio:Number):void
            {
                trace("Loading assets, progress:", ratio);
                if (ratio == 1)
                {
                    //TO DO in StarlingEngine, tranzitionToState does not manage non finished animations!!!!!!
                    //This needs to be fixed in order to have overlapping tranzitions
                    _stateTransition = new EngineStateTransition();
                    _stateTransition.injectAnimation(function(obj1:IAbstractDisplayObject, obj2:IAbstractDisplayObject):void{
                        obj2.y = -480;
                        TweenLite.to(obj1, .5, {y:480, ease:Cubic.easeOut, onComplete:_stateTransition.onTransitionComplete, onCompleteParams:[obj1, obj2]});
                        TweenLite.to(obj2, .3, {y:0, ease:Cubic.easeOut});
                    })

                    /*_loginState = new LoginState(_bridgeGraphics);
                    _bridgeGraphics.tranzitionToState(_loginState, _stateTransition)
                       */
                    //initConnections();
                    initBraid();
                }
            });
    }

    private function initConnections():void
    {
        // For emulation use directly simulationInit()
        simulationInit();

        // For mobile, use facebook connection
        // USE THE FACEBOOK LOGIN AS ID FOR NODE
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
        _connectingToServerState = new ConnectingToNode(_bridgeGraphics);
        //_bridgeGraphics.tranzitionToState(_connectingToServerState, _stateTransition)

        _nodeSocket = new NodeSocket(SERVER_IP, SERVER_PORT, _id, _playerType, _playerCountry);
        _nodeSocket.connect(socketConnected, onDataReceived);
        _nodeSocket.onErrorCallBack = caughtError;

        _strategy.makeNewLinkage(_resourceGathering, _transporter, _consumer);
        _strategy.makeNewLinkage(_resourceGathering, null, _transporter);

        _timer.addListenerToTimer(feedServer);
        _timer.addListenerToTimer(_strategy.step);
        _timer.startTimer();
    }

    private function socketConnected():void
    {
        _gameState = new GameState(_bridgeGraphics);
        _bridgeGraphics.tranzitionToState(_gameState, _stateTransition)
        _nodeSocket.writeMessage("test");
    }

    private function onDataReceived(obj:Object):void
    {
        _resourceGathering.workers = obj["data"]["miners"];
        _transporter.workers = obj["data"]["transporters"];
        _consumer.workers = obj["data"]["producers"];
        _gameState.receivedInformation(_timer.totalTimeSpent, obj, _consumer.units);
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

    private function caughtError(errorType:String, error:Object):void
    {
        _errorState = new ErrorState(_bridgeGraphics);
        _bridgeGraphics.tranzitionToState(_errorState, _stateTransition);
        _bridgeGraphics.addChild(_errorState);
    }
}
}
