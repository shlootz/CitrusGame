package objects {

import Box2D.Common.Math.b2Vec2;

import citrus.objects.NapePhysicsObject;
import citrus.objects.vehicle.nape.Nugget;

import com.pzuh.utils.Basic;

import flash.display.Bitmap;

import games.tinywings.nape.BirdHero;

import nape.callbacks.InteractionCallback;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.geom.Vec3;
import nape.phys.MassMode;

import signals.SignalsHub;

import starling.core.Starling;
	import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.Texture;

/**
	 * @author Aymeric
	 */
	public class DraggableCube extends NapePhysicsObject {

        public var grabbed:Boolean = false;
        public var cubeLife:uint = 3;

		protected var _hand:PivotJoint;
        protected var _mouseScope:DisplayObject;
        protected var _hero:BirdHero;
        protected var _viewBitmap:Bitmap;

        private var _touchOffsetX:Number;
        private var _touchOffsetY:Number;

        private var _signalsManager:SignalsHub;

		public function DraggableCube(name:String, params:Object = null, hero:BirdHero = null, viewBmp:Bitmap = null, signalsManager:SignalsHub = null)
		{
			super(name, params);
			this.touchable = true;
			this.updateCallEnabled = true;
            this.rotation = Math.random()*360;
            _hero = hero;
            _viewBitmap = viewBmp;
            _signalsManager = signalsManager;

            if(viewBmp != null) {
                var texture:Texture = Texture.fromBitmap(viewBmp);
                var img:Image = new Image(texture);

                this.view = img;
                this.view.width = this.width;
                this.view.height = this.height;
            }

		}
 
		override protected function createConstraint():void {
 
			super.createConstraint();
 
			_hand = new PivotJoint(_nape.space.world, _body,  Vec2.weak(),  Vec2.weak());
			_hand.active = false;
			_hand.stiff = false;
			_hand.space = _nape.space;
			_hand.maxForce = 20000;
		}
 
		override public function destroy():void {
 
			_hand.space = null;
 
			super.destroy();
		}
 
		override public function update(timeDelta:Number):void {
 
			super.update(timeDelta);
			
			/*if (_mouseScope) {
                _hand.anchor1.setxy((_ce.mouseX) / Starling.contentScaleFactor, (_ce.mouseY) / Starling.contentScaleFactor);
            }
             */
            if (this.x < _hero.x - 300)
                recycleMe();

		}

        public function recycleMe():void
        {
            var o:Object = {
                target:this
            }
            _signalsManager.dispatchSignal("recycleObject", "recycle", o)
        }

        public function killMe():void
        {
            kill = true;
        }
 
		public function enableHolding(mouseScope:DisplayObject, offsetX:Number, offsetY:Number, touchX:Number, touchY:Number):void {

            _mouseScope = mouseScope;

            //var angle:Number = Basic.getPointAngle(_hero.x, _hero.y, x, y);

            var angle:Number = rotation;

            rotation = Basic.radianToDegree(angle);

            var xDir:Number = Math.cos(angle) * 20000;
            var yDir:Number = Math.sin(angle) * 20000;

            this.body.applyImpulse(new Vec2(xDir, yDir));

            grabbed = true;
        }
 
		public function disableHolding():void {
 
			_hand.active = false;
			_mouseScope = null;
            //grabbed = false;
		}
 
	}
}