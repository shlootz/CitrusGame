package games.tinywings.nape {

import bridge.abstract.IAbstractTextField;

import citrus.core.CitrusObject;
import citrus.core.starling.StarlingState;
	import citrus.physics.nape.Nape;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingArt;

import flash.display.BitmapData;
import flash.display.BitmapDataChannel;

import flash.utils.Timer;
import flash.utils.clearInterval;
import flash.utils.setInterval;

import nape.geom.AABB;

import nape.geom.GeomPoly;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.shape.Polygon;

import objects.BadCube;

import objects.DraggableCube;
import objects.GoodCube;
import objects.Terrain;
import objects.TerrainHolder;

import starling.display.DisplayObject;

import starling.display.Quad;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;

import starlingEngine.elements.EngineState;

/**
	 * @author Aymeric
	 */
	public class TinyWingsGameState extends EngineState {
		
		[Embed(source="/../embed/1x/heroMobile.xml", mimeType="application/octet-stream")]
		public static const HeroConfig:Class;

		[Embed(source="/../embed/1x/heroMobile.png")]
		public static const HeroPng:Class;
		
		private var _nape:Nape;
		private var _hero:BirdHero;
        private var _distance:int = 0;
        private var _textField:TextField;
        private var _lifeTextField:TextField;
		
		private var _hillsTexture:HillsTexture;

        private var _step:uint = 0;

        private var _timer:uint;

		public function TinyWingsGameState() {
			super();
		}

		override public function initialize():void {
			
			super.initialize();
            _textField = new TextField(300,20,"0");
            _lifeTextField = new TextField(300,20,"100");

            addChild(_textField);
            addChild(_lifeTextField);

            _lifeTextField.y = _textField.y + 20;

			_nape = new Nape("nape");
            _nape.gravity = new Vec2(0, 150);
			_nape.visible = true;
			add(_nape);
			
			var bitmap:Bitmap = new HeroPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new HeroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var heroAnim:AnimationSequence = new AnimationSequence(sTextureAtlas, ["fly", "descent", "stop", "ascent", "throughPortal", "jump", "ground"], "fly", 30, true);
			StarlingArt.setLoopAnimations(["fly"]);
			
			_hero = new BirdHero("hero", {radius:50, view:heroAnim, group:1});
			add(_hero);
			
			_hillsTexture = new HillsTexture();

			var hills:HillsManagingGraphics = new HillsManagingGraphics("hills", {sliceHeight:150, sliceWidth:20, currentYPoint:350, registration:"topLeft", view:_hillsTexture});
			add(hills);
			
			view.camera.setUp(_hero,null,new Point(0.25 , 0.5), new Point(0.25,0.5));
            view.camera.allowZoom = true;
            view.camera.setZoom(.5);
            view.camera.allowRotation = true;

            stage.addEventListener(TouchEvent.TOUCH, _handleTouch);

            //add(new TerrainHolder(_nape));
		}

		override public function update(timeDelta:Number):void {

            super.update(timeDelta);

            // update the hills here to remove the displacement made by StarlingArt. Called after all operations done.
            _hillsTexture.update();

            _step++

            if (_step % 17 == 0) {
                var size:uint = 10+Math.random()*200;
                if(size%2 == 0) {
                    add(new BadCube("cube" + Math.random() * 99999, { view: new Quad(size, size, Math.random() * 0xffffff), width: size, height: size, x: _hero.x + 1000, y: _hero.y - 400}, _hero));
                }
                else
                {
                    add(new GoodCube("cube" + Math.random() * 99999, { view: new Quad(size, size, Math.random() * 0xffffff), width: size, height: size, x: _hero.x + 1000, y: _hero.y - 400}, _hero));
                }
            }

            _distance ++
            _textField.text = String(_distance);
            _lifeTextField.text = String(_hero.life);

           // view.camera.rotate(view.camera.getRotation()+2);
        }

        private function _handleTouch(tEvt:TouchEvent):void
        {

            var art:DisplayObject = (tEvt.target as DisplayObject).parent;

            var touchBegan:Touch = tEvt.getTouch(this, TouchPhase.BEGAN);
            var touchEnded:Touch = tEvt.getTouch(this, TouchPhase.ENDED);

            if (art && (touchBegan || touchEnded)) {

                var object:CitrusObject = (view.getObjectFromArt(art)) as CitrusObject;

                if (object) {

                    if (object is DraggableCube) {

                        if (touchBegan)
                            (object as DraggableCube).enableHolding(art, _hero.x ,_hero.y);
                        else if (touchEnded)
                            (object as DraggableCube).disableHolding();
                    }
                }
            }
        }
}
}
