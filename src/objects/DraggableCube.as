package objects {
 
	import citrus.objects.NapePhysicsObject;
import citrus.objects.vehicle.nape.Nugget;

import games.tinywings.nape.BirdHero;

import nape.callbacks.InteractionCallback;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.geom.Vec3;
import nape.phys.MassMode;

import starling.core.Starling;
	import starling.display.DisplayObject;
import starling.display.Quad;

/**
	 * @author Aymeric
	 */
	public class DraggableCube extends NapePhysicsObject {

        public var grabbed:Boolean = false;
        public var cubeLife:uint = 3;

		protected var _hand:PivotJoint;
        protected var _mouseScope:DisplayObject;
        protected var _hero:BirdHero;

        private var _touchOffsetX:Number;
        private var _touchOffsetY:Number;

		public function DraggableCube(name:String, params:Object = null, hero:BirdHero = null)
		{
			super(name, params);
			this.touchable = true;
			this.updateCallEnabled = true;
            _hero = hero;
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
			
			if (_mouseScope) {
                _hand.anchor1.setxy((_hero.x + _ce.mouseX) / Starling.contentScaleFactor, (_hero.y + _ce.mouseY) / Starling.contentScaleFactor);
            }

            if (this.x < _hero.x - 300)
                this.kill = true;
		}
 
		public function enableHolding(mouseScope:DisplayObject, offsetX:Number, offsetY:Number, touchX:Number, touchY:Number):void {

            _mouseScope = mouseScope;

            var mp:Vec2 = new Vec2(x, y);
            _hand.anchor2.set(_body.worldPointToLocal(mp, true));
            _hand.active = true;
            this.view = new Quad(this.width, this.height, 0xFF0000);

            grabbed = true;
        }
 
		public function disableHolding():void {
 
			_hand.active = false;
			_mouseScope = null;
            grabbed = false;
		}
 
	}
}