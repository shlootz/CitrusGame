package facebook{
import com.facebook.graph.FacebookMobile;
import com.freshplanet.ane.AirFacebook.Facebook;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.Loader;

import flash.display.Stage;

import flash.events.StatusEvent;
import flash.geom.Rectangle;
import flash.media.StageWebView;
import flash.utils.ByteArray;

public class FacebookConnect {

        private var _stage:Stage;

		private static const APP_ID:String = "1395615130691927";
		private static const PERMISSIONS:Array = ["email", "user_about_me", "user_birthday", "user_hometown", "user_website", "offline_access", "read_stream", "publish_stream", "read_friendlists"];
	    private var ACCESS_TOKEN:String = "CAAT1TfgbqVcBAEJfdKO2nmpFJbjVTNt1x9P5Bqj7zmVDk9jZB6jy8WGDmXumFZBHKsGZABQVkISuUSCaLWy9zu7wgfAi8LdDMowWi5LmtStUtNk96ilKQmaZCkZBCZApUtbJxC4tbAmDsqJ2biEDtAELwpyJF8M7ayxmdZBd0AhZC5SLQCB5ClYtGf47YO5juqaObe78tlklwX3N3Lpd074S";

		public function FacebookConnect(stage:Stage) {
            _stage = stage;
		}
		
		public function init():void {
            trace("Facebook.isSupported "+Facebook.isSupported);

            FacebookMobile.init(APP_ID, facebookInited, ACCESS_TOKEN)

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
            trace(FacebookMobile.getSession().uid);
            FacebookMobile.api("/me", onMeData);
        }
        else {
            var webview:StageWebView = new StageWebView();
            webview.viewPort = new Rectangle(0, 0, 400, 400);

            FacebookMobile.login(onLogin, _stage, PERMISSIONS, webview);
        }
    }

    private function onMeData(success:Object, fail:Object):void {
        if(success)
        {
            trace(success);
            FacebookMobile.api("/me/friends",onApiCallFriends);
            FacebookMobile.api("/me/picture", onMyPicReceived)
        }
    }

    private function onMyPicReceived(success:Object, fail:Object){
        var byteArray:ByteArray;
        var bmpData:BitmapData
        if(success)
        {
            trace(success);
            byteArray = success as ByteArray;
            bmpData = ByteArray as BitmapData;

            var loader:Loader = new Loader();
            loader.loadBytes(byteArray);
            bmpData.draw(loader);

            _stage.addChild(new Bitmap(bmpData));
        }
        else
        {
            trace("Pic Error "+fail);
            byteArray = fail as ByteArray;
            bmpData = ByteArray as BitmapData;
            _stage.addChild(new Bitmap(bmpData));
        }
    }

    private function onApiCallFriends(success:Object, fail:Object):void
    {
        if (success)
        {
            var friends:Array = success as Array;
            trace("Friends:"+friends);
        }
        else
        {
            trace("Friends Error "+fail);
        }
    }

        private function onLogin(success:Object,fail:Object):void
        {
            if(success)
            {
                trace(FacebookMobile.getSession().accessToken);
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
