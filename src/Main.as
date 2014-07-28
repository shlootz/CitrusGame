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

    private var socket:XMLSocket

    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World Citrus Game";
        addChild(textField);
        socket = new XMLSocket("127.0.0.1", 9001);

        socket.addEventListener(Event.CONNECT, onConnect);
        socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
    }

    private function onConnect(event:Event):void {
        trace("connected");
        socket.removeEventListener(Event.CONNECT, onConnect);
        socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);

        socket.addEventListener(DataEvent.DATA, onDataReceived);
        socket.addEventListener(Event.CLOSE, onSocketClose);
    }

    private function onDataReceived(event:DataEvent):void {

    }

    private function onSocketClose(event:Event):void {

    }

    private function onError(event:IOErrorEvent):void {
        trace("error "+event)
    }
}
}
