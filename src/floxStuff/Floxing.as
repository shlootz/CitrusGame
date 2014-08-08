/**
 * Created by adm on 30.07.14.
 */
package floxStuff {
import bridge.abstract.IAbstractState;

import com.gamua.flox.AuthenticationType;
import com.gamua.flox.Flox;
import com.gamua.flox.Player;

public class Floxing {

    private var _display:IAbstractState;
    private var _player:Player;
    private var _facebookKey:String;
    private var _floxAuthentificationOnComplete:Function;

    public function Floxing(uid:String, floxAuthentificationOnComplete:Function) {
        _facebookKey = uid;
        _floxAuthentificationOnComplete = floxAuthentificationOnComplete;
    }

    public function init():void
    {
        Flox.init("YNclogVX3tC53ete", "P5Id3jtxxpFf3dtn", "0.9");

        //Check if the current player is a guest. If so, this is the first start
        //of the game and the player has not yet been authenticated.
        if(Player.current.authType == AuthenticationType.GUEST) {
            //Player.current points to a guest player. We need to find/create
            //this player's foreign key and log the player in.
            var key:String = _facebookKey;

            //Now since we have the key, let's login the player.
            Player.loginWithKey(key,
                    function onComplete(player:Player):void {
                        //The player is now logged in.
                        //We can continue with the game logic.
                        trace("Flox auth succesful");
                        _player = player;
                        _floxAuthentificationOnComplete.call();
                    },
                    function onError(message:String):void {
                        //An error occurred: Handle it.
                        trace("Flox first auth error "+message)
                    }
            );
        } else {
            //Player is already logged in. This is not the first game start.
            //We can continue to use Player.current in our game.
            //In order to get the current players server state we need to call
            //refresh on the player.
            Player.current.refresh(
                    function onComplete(player:Player):void {
                        //The player has now been refreshed.
                        //We can continue with the game logic.
                        trace("player refresh complete")
                    },
                    function onError(message:String):void {
                        //An error occurred: Handle it.
                        trace("player error "+message);
                    }
            );
        }
    }

    public function get player():Player {
        return _player;
    }

    public function get display():IAbstractState {
        return _display;
    }

    public function set display(value:IAbstractState):void {
        _display = value;
    }
}
}
