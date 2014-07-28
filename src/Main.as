package {

import com.pnwrain.flashsocket.FlashSocket;
import com.pnwrain.flashsocket.events.FlashSocketEvent;

import flash.display.Sprite;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.XMLSocket;
import flash.text.TextField;
import com.pnwrain.flashsocket.events.FlashSocketEvent;

public class Main extends Sprite {

    private var _id:String = "PlayerName"+String(Math.random()*99999);
    private var _connectionObject:Object = new Object();
    private var _nodeSocket:NodeSocket = new NodeSocket("127.0.0.1", 9001, _id);

    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World Citrus Game";
        addChild(textField);

        _nodeSocket.connect(socketConnected);
    }

    private function socketConnected():void
    {
        _nodeSocket.writeMessage("muie");
    }
}
}
