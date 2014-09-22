package games.tinywings.nape {

import bridge.abstract.AbstractPool;
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
import objects.BulletCube;

import objects.DraggableCube;
import objects.GoodCube;
import objects.Terrain;
import objects.TerrainHolder;

import org.osflash.signals.Signal;

import signals.SignalsHub;

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
	 * @author Alex Popescu
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
        private var _signalsManager:SignalsHub = new SignalsHub();
		
		private var _hillsTexture:HillsTexture;

        private var _step:uint = 0;

        private var _grabbedObjects:Array = new Array();

        private var _draggableCubesPool:AbstractPool;

		public function TinyWingsGameState() {
			super();
		}

		override public function initialize():void {
			
			super.initialize();
            var anchors:Vector.<Function> = new Vector.<Function>();
            anchors.push(onBreakObject);

            var anchorsGrabbed:Vector.<Function> = new Vector.<Function>();
            anchorsGrabbed.push(onGrabbedObject);

            var anchorsDropped:Vector.<Function> = new Vector.<Function>();
            anchorsDropped.push(onDroppedObject);

            _signalsManager.addSignal("breakObject", new Signal(), anchors);
            _signalsManager.addSignal("grabbedObject", new Signal(), anchorsGrabbed);
            _signalsManager.addSignal("droppedObject", new Signal(), anchorsDropped)

            _textField = new TextField(300,20,"0");
            _lifeTextField = new TextField(300,20,"100");

            addChild(_textField);
            addChild(_lifeTextField);

            _lifeTextField.y = _textField.y + 20;

			_nape = new Nape("nape");
            _nape.gravity = new Vec2(0, 100);
			//_nape.visible = true;
			add(_nape);
			
			var bitmap:Bitmap = new HeroPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new HeroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var heroAnim:AnimationSequence = new AnimationSequence(sTextureAtlas, ["fly", "descent", "stop", "ascent", "throughPortal", "jump", "ground"], "fly", 30, true);
			StarlingArt.setLoopAnimations(["fly"]);
			
			_hero = new BirdHero("hero", {radius:50, view:heroAnim, group:1}, _signalsManager);
			add(_hero);
			
			_hillsTexture = new HillsTexture();

			var hills:HillsManagingGraphics = new HillsManagingGraphics("hills", {sliceHeight:15, sliceWidth:20, currentYPoint:350, registration:"topLeft", view:_hillsTexture});
			add(hills);
			
			view.camera.setUp(_hero,null,new Point(0.25 , 0.5), new Point(0.25,0.5));
            view.camera.allowZoom = true;
            view.camera.setZoom(.5);
            view.camera.allowRotation = true;

            stage.addEventListener(TouchEvent.TOUCH, _handleTouch);

            _draggableCubesPool = new AbstractPool("draggableCubes", DraggableCube, 1000, "smallCube", null, _hero);

            //add(new TerrainHolder(_nape));
		}

		override public function update(timeDelta:Number):void {

            super.update(timeDelta);

            // update the hills here to remove the displacement made by StarlingArt. Called after all operations done.
            _hillsTexture.update();

            _step++

            if (_step % 37 == 0) {

                var size:uint = 10+Math.random()*200;
                var generate:int = int(Math.random()*3);

                trace(generate);

                if(generate == 0)
                {
                    add(new BadCube("cube" + Math.random() * 99999, { view: new Quad(size, size, 0x000000), width: size, height: size, x: _hero.x + 1000 + Math.random()*300, y: _hero.y - 600}, _hero));
                }
                if(generate == 1)
                {
                    add(new BulletCube("cube" + Math.random() * 99999, { view: new Quad(100, 100, 0x00FF00), width: 100, height: 100, x: _hero.x + 1000 + Math.random()*500, y: _hero.y - 400}, _hero));
                }
                if(generate == 2)
                {
                    add(new GoodCube("cube" + Math.random() * 99999, { view: new Quad(100, 100, 0xFF0000), width: 100, height: 100, x: _hero.x + 1000 + Math.random()*500, y: _hero.y - 400}, _hero));
                }
            }

            _distance = _hero.x;
            _textField.text = String(_distance);
            _lifeTextField.text = String(_hero.life);

            if(_grabbedObjects.length > 4)
            {
                _hero.body.velocity.x = 300;
            }
           // view.camera.rotate(view.camera.getRotation()+2);
        }

        private function _handleTouch(tEvt:TouchEvent):void
        {

            var art:DisplayObject = (tEvt.target as DisplayObject).parent;

            var touchBegan:Touch = tEvt.getTouch(this, TouchPhase.BEGAN);
            var touchMoved:Touch = tEvt.getTouch(this, TouchPhase.MOVED);
            var touchEnded:Touch = tEvt.getTouch(this, TouchPhase.ENDED);

            if (art && (touchBegan || touchEnded)) {

                var object:CitrusObject = (view.getObjectFromArt(art)) as CitrusObject;

                if (object) {

                    if (object is DraggableCube) {

                        if (touchBegan) {
                            (object as DraggableCube).enableHolding(art, _hero.x, _hero.y, touchBegan.globalX, touchBegan.globalY);
                            //_signalsManager.dispatchSignal("grabbedObject", "grabbedObject", {target:object})
                        }

                        if (touchEnded){
                            (object as DraggableCube).disableHolding();
                            //_signalsManager.dispatchSignal("droppedObject", "droppedObject", {target:object})
                        }
                    }
                }
            }
        }

        private function onBreakObject(type:String, obj:Object):void
        {
            var target:BadCube = obj["target"] as BadCube;
            var w:uint = target.width;
            var h:uint = target.height;
            var posX:uint = target.x;
            var posY:uint = target.y;

            var pieces:uint = Math.random()*100;
            var piecesSize:uint = (2+w/pieces)*2;

            var piecesW:uint = Math.sqrt(pieces);
            var piecesH:uint = Math.sqrt(pieces);

            for(var i:uint = 0; i<piecesW; i++)
            {
                for(var j:uint = 0; j<piecesH; j++)
                {
                    var smallCube:DraggableCube = new DraggableCube("smallCube" + i+j, { view: new Quad(piecesSize, piecesSize, 0x000000), width: piecesSize, height: piecesSize, x: _hero.x + 1000, y: _hero.y - 400}, _hero);
                    //var smallCube:DraggableCube = _draggableCubesPool.getNewObject() as DraggableCube;
                    //smallCube.view = new Quad(piecesSize, piecesSize, 0x000000);
                    //smallCube.width = piecesSize;
                    //smallCube.height = piecesSize;
                    //smallCube.x = _hero.x + 1000;
                    //smallCube.y = _hero.y - 400;
                    smallCube.x = posX + piecesSize*i*2 - Math.random()*w/2;
                    smallCube.y = posY + piecesSize*i*2 - Math.random()*h/2;
                    add(smallCube);
                }
            }
            target.destroyCube();
        }

        private function onGrabbedObject(type:String, obj:Object):void
        {
            _grabbedObjects.push(obj);
        }

        private function onDroppedObject(type:String, obj:Object):void
        {
            for(var i:uint = 0; i<_grabbedObjects.length; i++)
            {
                if(_grabbedObjects[i] == obj)
                {
                    _grabbedObjects.slice(i-1, i);
                }
            }
        }
}
}
