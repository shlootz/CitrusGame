package games.tinywings.nape {

	import citrus.objects.platformer.nape.Hero;
	import citrus.objects.platformer.nape.Platform;

	import nape.callbacks.CbType;
	import nape.callbacks.InteractionType;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreFlag;
	import nape.callbacks.PreListener;
	import nape.geom.Vec2;

import objects.BadCube;

import objects.DraggableCube;
import objects.GoodCube;

import signals.SignalsHub;

/**
	 * @author Alex Popescu
	 */
	public class BirdHero extends Hero {

		public var jumpDecceleration:Number = 7;
        public var life:uint = 3;

		private var _mobileInput:TouchInput;
		private var _preListener:PreListener;

        private var _signalsManager:SignalsHub;

		public function BirdHero(name:String, params:Object = null, signalsManager:SignalsHub = null) {

			super(name, params);
            _signalsManager = signalsManager;
			//_mobileInput = new TouchInput();
			//_mobileInput.initialize();
		}

		override public function destroy():void {

			_preListener.space = null;
			_preListener = null;

			_mobileInput.destroy();

			super.destroy();
		}

		override public function update(timeDelta:Number):void {
            body.allowRotation = true;
			var velocity:Vec2 = _body.velocity;
			
			velocity.x = 250;
			
		/*	if (_mobileInput.screenTouched) {

				if (_onGround) {

					velocity.y = -jumpHeight;
					_onGround = false;

				} else if (velocity.y < 0)
					velocity.y -= jumpAcceleration;
				else
					velocity.y -= jumpDecceleration;
			}*/

			_body.velocity = velocity;

			_updateAnimation();
		}

		private function _updateAnimation():void {

			/*if (_mobileInput.screenTouched) {

				_animation = _body.velocity.y < 0 ? "jump" : "ascent";

			} else if (_onGround)
				_animation = "fly";
			else
				_animation = "descent";
				*/
            if (_onGround)
                _animation = "fly";
            else
                _animation = "descent";
		}

		override protected function createConstraint():void {

			super.createConstraint();

			_preListener = new PreListener(InteractionType.ANY, CbType.ANY_BODY, CbType.ANY_BODY, handlePreContact);
			_body.space.listeners.add(_preListener);
		}

		override public function handlePreContact(callback:PreCallback):PreFlag {

			if (callback.int2.userData.myData is Platform)
				_onGround = true;

            if(callback.int1.userData.myData is BadCube && callback.int2.userData.myData is BadCube) {
                if((callback.int1.userData.myData as DraggableCube).grabbed) {
                    _signalsManager.dispatchSignal("breakObject", "breakObject", {target: callback.int2.userData.myData});
                    (callback.int1.userData.myData as DraggableCube).cubeLife --

                    if((callback.int1.userData.myData as DraggableCube).cubeLife == 0)
                    {
                        _signalsManager.dispatchSignal("breakObject", "breakObject", {target: callback.int1.userData.myData});
                    }
                }
            }

            if(callback.int1.userData.myData is BirdHero && callback.int2.userData.myData is BadCube) {
                if (life > 0)
                {
                    life--
                    _signalsManager.dispatchSignal("breakObject", "breakObject", {target:callback.int2.userData.myData})
                }
                else
                {
                    _signalsManager.dispatchSignal("breakObject", "breakObject", {target:callback.int2.userData.myData})
                    die();
                }
            }

            if(callback.int1.userData.myData is BirdHero && callback.int2.userData.myData is GoodCube) {
                (callback.int2.userData.myData as GoodCube).destroyCube();
                if(life < 100) {
                    life++
                }
            }


            return PreFlag.ACCEPT;
		}

        private function die():void
        {
            trace("DEAD");
        }

	}
}
