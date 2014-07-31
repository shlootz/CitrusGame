package facebook{
import com.facebook.graph.FacebookMobile;
import com.freshplanet.ane.AirFacebook.Facebook;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.Loader;

import flash.display.Stage;
import flash.events.Event;
import flash.events.IOErrorEvent;

import flash.events.StatusEvent;
import flash.geom.Rectangle;
import flash.media.StageWebView;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import localStorage.SaveOrRetrieve;

public class FacebookConnect {

        private var _stage:Stage;
        private var _connectedCallBack:Function;

		private static const APP_ID:String = "1395615130691927";
		private static const PERMISSIONS:Array = ["email", "user_about_me", "user_birthday", "user_hometown", "user_website", "user_photos", "offline_access", "read_stream", "publish_stream", "read_friendlists", "user_friends"];
	//    private var ACCESS_TOKEN:String = "CAACEdEose0cBAJBOffMGR5r1YBbNaUTKTlBmAW2OG76pkHvTa9Tmq85BNwVbGFfqcSqm5i451LtvHSQAYgTaiG84KAqm7mot6z4JNGG3hJW01ZAZBtr3QMrvhjJZAuFqSTmuvnNhRW5MRZAFZAHrV7tmyBsYNEClAMu98qufxAeZBGefD8LcfzlGJrzZCuOztgrU1SZC5XJUgOfRRQ4cvHZCE";
        private var ACCESS_TOKEN:String = "";

    private var _user:Object;

		public function FacebookConnect(stage:Stage, connectedCallback:Function) {
            _stage = stage;
            _connectedCallBack = connectedCallback;
		}
		
		public function init():void {
            trace("Facebook.isSupported "+Facebook.isSupported);
            var accToken:String = SaveOrRetrieve.getItem("auth") as String;
            trace("From local "+accToken);

            FacebookMobile.init(APP_ID, facebookInited, ACCESS_TOKEN)
        }

    private function facebookInited(success:Object, fail:Object):void {

        //newLogin();

        if(success)
        {
            trace("already logged in")
            trace(FacebookMobile.getSession().uid);
            trace(FacebookMobile.getSession().accessToken);

            var loader:Loader = new Loader();
            loader.load(new URLRequest(FacebookMobile.getImageUrl(FacebookMobile.getSession().uid)));

            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadingError);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,doneLoad);

            FacebookMobile.api("/me", function(success:Object, fail:Object):void {
                if(success)
                {
                    trace("/me succeded"+success);
                    _user = success;
                }
                else
                {
                    trace("/me failed"+fail);
                }
            });

            FacebookMobile.api("/me/friends", function(success:Object, fail:Object):void {
                if(success)
                {
                    trace("/me/friends succeded"+success);
                }
                else
                {
                    trace("/me/friends failed"+fail);
                }
            });

        }
        else {
           newLogin();
        }
    }

    private function newLogin():void
    {
        var webview:StageWebView = new StageWebView();
        webview.viewPort = new Rectangle(0, 0, 400, 400);

        FacebookMobile.login(onLogin, _stage, PERMISSIONS, webview);
    }

    private function doneLoad(e:Event):void
    {
        var bm:Bitmap = e.target.content as Bitmap;
        bm.smoothing = true;
        bm.x = 10;
        bm.y = 10;
        bm.width = 80;
        bm.height = 80;

        _stage.addChild(bm);
    }

    private function loadingError(e:IOErrorEvent):void
    {
         trace("Picture error loading");
    }

        private function onLogin(success:Object,fail:Object):void
        {
            if(success)
            {
                trace(FacebookMobile.getSession().accessToken);
                trace('facebook connected');
                _connectedCallBack.apply(null, [FacebookMobile.getSession().uid]);
                SaveOrRetrieve.saveItem("auth", FacebookMobile.getSession().accessToken);
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
