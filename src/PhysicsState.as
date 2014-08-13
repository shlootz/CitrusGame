package  
{
	import citrus.core.CitrusObject;
	import citrus.objects.NapePhysicsObject;
	import citrus.objects.platformer.nape.Platform;
	import citrus.physics.nape.Nape;

	import nape.geom.Vec2;
    import nape.geom.AABB;
    import nape.geom.Geom;
    import nape.geom.GeomPoly;
    import nape.geom.GeomPolyList;
    import nape.geom.MarchingSquares;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.phys.Material;
    import nape.shape.Circle;
    import nape.shape.Polygon;
    import nape.space.Broadphase;

	import objects.DraggableCube;
	import starling.display.DisplayObject;
	import starling.display.Quad;
import starling.events.Event;
import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingEngine.elements.EngineState;
	/**
	 * ...
	 * @author Eu
	 */
	public class PhysicsState extends EngineState
	{
        var nape:MyNape;
        private var _planetaryBodies:Array;
        private var _samplePoint:Body;

		public function PhysicsState() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();

            _samplePoint = new Body();
            _samplePoint.shapes.add(new Circle(0.001));

			
			nape = new MyNape("nape");
            nape.updateCallEnabled = true;
			nape.visible = true;
			nape.gravity = new Vec2(0, 0);
			add(nape);
			
			add(new Platform("borderBottom", { x:400, y:600 - 10, width:800, height:10 } ));
			add(new Platform("borderLeft", { x:0, y:300, width:10, height:600 } ));
			add(new Platform("borderRight", { x:800 - 10, y:300, width:10, height:600 } ));
			add(new Platform("borderTop", { x:400 , y:0, width:800, height:10 } ));
			
			for (var i:uint = 0; i < 300; i++ )
			{
				var w:Number = Math.random() * 50;
				add(new DraggableCube("cube"+i, { view:new Quad(w,w, Math.random()*0xffffff), width:w, height:w, x:Math.random()*800, y:Math.random()*600 } ));
			}

            //var dg:DraggableCube = new DraggableCube("cube", { view:new Quad(200,200, Math.random()*0xffffff), width:200, height:200, x:50, y:50} )

            stage.addEventListener(TouchEvent.TOUCH, _handleTouch);
		}

        override public function update(deltaTime:Number):void
        {
            super.update(deltaTime);

            for (var i:int = 0; i < _planetaryBodies.length; i++) {
                var planet:Body = _planetaryBodies[i];
                planetaryGravity(planet, deltaTime);
            }
        }

        private function planetaryGravity(planet:Body, deltaTime:Number):void {
            // Apply a gravitational impulse to all bodies
            // pulling them to the closest point of a planetary body.
            //
            // Because this is a constantly applied impulse, whose value depends
            // only on the positions of the objects, we can set the 'sleepable'
            // of applyImpulse to be true and permit these bodies to still go to
            // sleep.
            //
            // Applying a 'sleepable' impulse to a sleeping Body has no effect
            // so we may as well simply iterate over the non-sleeping bodies.
            var closestA:Vec2 = Vec2.get();
            var closestB:Vec2 = Vec2.get();

            for (var i:int = 0; i < nape.space.liveBodies.length; i++) {
                var body:Body = nape.space.liveBodies.at(i);
                // Find closest points between bodies.
                _samplePoint.position.set(body.position);
                var distance:Number = Geom.distanceBody(planet, _samplePoint, closestA, closestB);

                // Cut gravity off, well before distance threshold.
                if (distance > 100) {
                    continue;
                }

                // Gravitational force.
                var force:Vec2 = closestA.sub(body.position, true);

                // We don't use a true description of gravity, as it doesn't 'play' as nice.
                force.length = body.mass * 1e6 / (distance * distance);

                // Impulse to be applied = force * deltaTime
                body.applyImpulse(
                        /*impulse*/ force.muleq(deltaTime),
                        /*position*/ null, // implies body.position
                        /*sleepable*/ true
                );
            }

            closestA.dispose();
            closestB.dispose();
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
							(object as DraggableCube).enableHolding(art);
						else if (touchEnded)
							(object as DraggableCube).disableHolding();
					}
				}
			}
		}
		
	}

}