package facebook{
import com.facebook.graph.FacebookMobile;
import com.freshplanet.ane.AirFacebook.Facebook;

import flash.display.Stage;

import flash.events.StatusEvent;
import flash.geom.Rectangle;
import flash.media.StageWebView;

public class FacebookConnect {

        private var _stage:Stage;

		private static const APP_ID:String = "1395615130691927";
		private static const PERMISSIONS:Array = ["email", "user_about_me", "user_birthday", "user_hometown", "user_website", "offline_access", "read_stream", "publish_stream", "read_friendlists"];
		
		public function FacebookConnect(stage:Stage) {
            _stage = stage;
		}
		
		public function init():void {
            trace("Facebook.isSupported "+Facebook.isSupported);

            FacebookMobile.init(APP_ID, facebookInited)

           /* if (Facebook.isSupported) {
                _facebook = Facebook.getInstance();
                _facebook.addEventListener(StatusEvent.STATUS, handler_status);
                _facebook.init(APP_ID);

                if (_facebook.isSessionOpen) {
                    _facebook.dialog("oauth", null, handler_dialog, true);
                } else {
                    _facebook.openSessionWithPublishPermissions(PERMISSIONS, handler_openSessionWithPermissions);
                }
            }
            */
        }

    private function facebookInited(success:Object, fail:Object):void {
        if(success)
        {
            trace("already logged in")
        }
        else {
            var webview:StageWebView = new StageWebView();
            webview.viewPort = new Rectangle(0, 0, 400, 400);

            FacebookMobile.login(onLogin, _stage, [], webview);
        }
    }

        private function onLogin(success:Object,fail:Object):void
        {
            if(success)
            {
                trace('facebook connected');
            } else {
                trace('facebook error');
        }
        }

        private function handler_status(event:StatusEvent):void {
            trace("!!! "+event);
        }

        private function handler_dialog(event:Object):void {

        }

        private function handler_openSessionWithPermissions(event:Object):void {

        }

        }
}
