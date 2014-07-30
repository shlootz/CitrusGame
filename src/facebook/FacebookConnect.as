package facebook{
import com.freshplanet.ane.AirFacebook.Facebook;

import flash.display.Bitmap;

import flash.display.BitmapData;

import flash.display.SimpleButton;

import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
    import flash.text.TextField;


	public class FacebookConnect extends Sprite {

		private static const APP_ID:String = "1395615130691927";
		private static const PERMISSIONS:Array = ["email", "user_about_me", "user_birthday", "user_hometown", "user_website", "offline_access", "read_stream", "publish_stream", "read_friendlists"];
		
		private var _facebook:Facebook;

        private var _tField:TextField = new TextField();
		
		public function FacebookConnect() {
			super();
            _tField.y = 100;
            _tField.width = 500;
            _tField.height = 400;
            addChild(_tField);
		}
		
		public function init():void
		{
			showInfo('facebook.isSupported:', Facebook.isSupported);
			if(Facebook.isSupported)
			{
				_facebook = Facebook.getInstance();
				_facebook.addEventListener(StatusEvent.STATUS, handler_status);
				_facebook.init(APP_ID);
				
				showInfo("isSeesionOpen:", _facebook.isSessionOpen);
				if(_facebook.isSessionOpen)
				{
					_facebook.dialog("oauth", null, handler_dialog, true);
				}else{
                    //_facebook.openSessionWithPermissions(PERMISSIONS, handler_openSessionWithPermissions);
                    _facebook.openSessionWithPublishPermissions(PERMISSIONS, handler_openSessionWithPermissions);
                    //_facebook.dialog("oauth", null, handler_dialog);
				}
			}
		}
		
		protected function handler_infoBTNclick($evt:MouseEvent):void
		{
			//_facebook.requestWithGraphPath("/me", null, "GET", handler_requesetWithGraphPath);
			_facebook.requestWithGraphPath("/me/friends", null, "GET", handler_requesetWithGraphPath);

		}
		
		protected function handler_status($evt:StatusEvent):void
		{
			showInfo("statusEvent,type:", $evt.type,",code:", $evt.code,",level:", $evt.level);
		}
		
		private function handler_openSessionWithPermissions($success:Boolean, $userCancelled:Boolean, $error:String = null):void
		{
			if($success)
			{

			}
			showInfo("success:", $success, ",userCancelled:", $userCancelled, ",error:", $error);
		}
		
		private function handler_dialog($data:Object):void
		{
			showInfo('handler_dialog:', JSON.stringify($data));
		}
		
		private function handler_requesetWithGraphPath($data:Object):void
		{
			showInfo("handler_requesetWithGraphPath:", JSON.stringify($data));  
		}
		
		private function showInfo(...$args):void
		{
			var __msg:String = "";
			for (var i:int = 0; i < $args.length; i++) 
			{
				__msg += $args[i] + " ";
			}
			__msg += "\n";
			//infoTA.appendText(__msg);
            _tField.appendText(String(__msg));
		}
	}
}
