package
{
     import flash.events.Event;
     import flash.events.EventDispatcher;
     import flash.events.IOErrorEvent;
     import flash.events.ProgressEvent;
     import flash.events.SecurityErrorEvent;
     import flash.net.Socket;
     import flash.text.TextField;
 
     public class NodeSocket
     {
          private var _socket:Socket;
          private var _beenVerified:Boolean;
 
          private var _serverUrl:String;
          private var _port:int;
		  private var _nickName:String;
          private var _country:String;
          private var _key:String;

          private var _onConnectCallback:Function;
          private var _onDataReceivedCallback:Function;
 
          public function NodeSocket(url:String, port:int, nickName:String, key:String, country:String):void {
               this._serverUrl = url;
               this._port = port;
			   this._nickName = nickName;
               this._key = key;
               this._country = country;
          }
 
          public function connect(callBack:Function, onDataCallback:Function):void
          {
              _onConnectCallback = callBack;
              _onDataReceivedCallback = onDataCallback;

               cleanUpSocket();
 
               _socket = new Socket();
               _socket.addEventListener(Event.CONNECT, onSocketConnect);
               _socket.addEventListener(Event.CLOSE, onSocketDisconnect);
               _socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
               _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
               _socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
 
               _socket.connect(this._serverUrl, this._port);
          }
 
          private function onSocketConnect(e:Event):void
          {
               trace("Connected");
			   var objToJson = {"nickName":_nickName, "msg":"connecting", "type":_key, "country":_country};
			  _socket.writeUTFBytes(JSON.stringify(objToJson));
              _socket.flush();

              _onConnectCallback.call();
          }
 
          private function onSocketDisconnect(e:Event):void
          {
			  trace("Disconnected");
               disconnectSocket();
          }
 
          private function onSecurityError(e:SecurityErrorEvent):void
          {
			  trace("Security Error");
               disconnectSocket();
          }
 
          private function onIOError(e:IOErrorEvent):void
          {
			  trace("Error")
               disconnectSocket();
          }
 
          private function onSocketData(e:ProgressEvent):void
          {
               var message:String = _socket.readUTFBytes(_socket.bytesAvailable);
 				trace("Received :  "+message);
               //_beenVerified is set so that we don't interpret
               //the Cross Domain response as an actual message
               if(_beenVerified)
               {
                   // trace(message);
               }
               else
               {
                    _beenVerified = true;
                }

              _onDataReceivedCallback.apply("Received",[JSON.parse(message)])
          }
 
          public function writeMessage(message:String, type:String="", obj:Object = null):void
          {
			  
			  var objToJson = {
				  "nickName":_nickName, 
				  "msg":message,
                  "type":type,
                  "obj":obj,
                  "country":_country
				  };
				  
			   trace("Sending : "+objToJson);	 

              try {
                  _socket.writeUTFBytes(JSON.stringify(objToJson));
                  _socket.flush();
              } catch (e:Error)
              {
                  trace("Server crashed, cleaning socket");
                  disconnectSocket();
              }
          }
 
          private function disconnectSocket():void
          {
			  trace("Disconnect Socket")
               cleanUpSocket();
          }
 
          private function cleanUpSocket():void
          {
			  trace("Cleanup Socket");
               if(_socket != null)
               {
                    if(_socket.connected)
					{
						writeMessage("exit\0");
                         _socket.close();
					}
 
                    _beenVerified = false;
                    _socket = null;
               }
          }
     }
}