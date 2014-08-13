/**
 * Created by adm on 08.08.14.
 */
package gameGraphics.game {
import bridge.IBridgeGraphics;
import bridge.abstract.IAbstractMovie;
import bridge.abstract.IAbstractState;
import bridge.abstract.IAbstractTextField;
import bridge.abstract.ui.IAbstractLabel;

import citrus.core.CitrusObject;
import citrus.objects.NapePhysicsObject;

import citrus.objects.platformer.nape.Platform;

import citrus.physics.nape.Nape;

import flash.display.BitmapData;
import flash.geom.Point;

import gameGraphics.AbstractState;

import nape.geom.Vec2;
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
import nape.space.Space;


import objects.DraggableCube;

import starling.display.DisplayObject;

import starling.display.Quad;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class GameState extends AbstractState{

    private var _nape:Nape;
    private var _space:Space;
    private var _planetaryBodies:Array = new Array();
    private var _samplePoint:Body = new Body();

    private var _earningsLabel:IAbstractLabel;
    private var _totalProducedLabel:IAbstractLabel;
    private var _mouse:IAbstractMovie;

    private var _scale:Number = 1;

    public function GameState(graphicsEngine:IBridgeGraphics) {
        super(graphicsEngine);

        var tTextEarnings:IAbstractTextField = _bridgeGraphics.requestTextField(250, 30, "0", "Verdana", 30);
        _earningsLabel = _bridgeGraphics.requestLabelFromTextfield(tTextEarnings, "earnedLabel");

        var tTextTotalProduced:IAbstractTextField = _bridgeGraphics.requestTextField(250, 30, "0", "Verdana", 30);
        _totalProducedLabel = _bridgeGraphics.requestLabelFromTextfield(tTextTotalProduced, "earnedLabel");

        addNewChild(_bridgeGraphics.requestImageFromBitmapData(new BitmapData(800,480,false, 0xFFFFFF)));

        addNewChild(_earningsLabel);

        _totalProducedLabel.y = 40;
        addNewChild(_totalProducedLabel);


        //_mouse = _bridgeGraphics.requestMovie("star");
        //_mouse.scaleX = _mouse.scaleY = _scale;
        //_mouse.x = _mouse.y = 100;
        //addNewChild(_mouse);

        trace("=> GAME STATE");
    }

    override public function initialize():void
    {
        super.initialize();

        _nape = new Nape("nape");

        _nape.visible = true;
        _nape.gravity = new Vec2(0, 0);
        add(_nape);

        _space = _nape.space;

        add(new Platform("borderBottom", { x:400, y:600 - 10, width:800, height:10 } ));
        add(new Platform("borderLeft", { x:0, y:300, width:10, height:600 } ));
        add(new Platform("borderRight", { x:800 - 10, y:300, width:10, height:600 } ));
        add(new Platform("borderTop", { x:400 , y:0, width:800, height:10 } ));

        var planet:Planet = new Planet("planet");
        _planetaryBodies.push(planet);
        add(planet);
        //planet.space = _nape.space;

        var planetCitrusObject:NapePhysicsObject = new NapePhysicsObject("planetoid", {body:planet});
        var draggablePlanet:DraggableCube = new DraggableCube("asd");
        add(planetCitrusObject)
        addRandomBodies();

        stage.addEventListener(TouchEvent.TOUCH, _handleTouch);

        _nape.updateCallEnabled = true;
    }

    private function addRandomBodies():void
    {
        for (var j:uint = 0; j < 30; j++ )
        {
            var wj:Number = Math.random() * 30;
            var dgj:DraggableCube = (new DraggableCube("cube"+j, { view:new Quad(wj,wj, Math.random()*0xffffff), width:wj, height:wj, x:Math.random()*800, y:Math.random()*600 } ));
            add(dgj);
        }

    }

    override public function update(deltaTime:Number):void
    {
        try {
            super.update(deltaTime);
        }
        catch (e:Error)
        {
            trace("CAUGHT "+e);
        }
        for (var i:int = 0; i < _planetaryBodies.length; i++) {
            var planet:Body = _planetaryBodies[i].body;
            planetaryGravity(planet, deltaTime);
        }
    }

    function DistanceTwoPoints(x1:Number, x2:Number,  y1:Number, y2:Number):
            Number {
        var dx:Number = x1-x2;
        var dy:Number = y1-y2;
        return Math.sqrt(dx * dx + dy * dy);
    }

    private function planetaryGravity(planet:Body, deltaTime:Number):void
    {
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

        for (var i:int = 0; i < _nape.space.liveBodies.length; i++) {
            var body:Body = _nape.space.liveBodies.at(i);
            // Find closest points between bodies.
            _samplePoint.position.set(body.position);
            var distance:Number = Geom.distanceBody(planet, _samplePoint, closestA, closestB);
            var p1:Point = new Point(planet.position.x, planet.position.y);
            var p2:Point = new Point(_samplePoint.position.x, _samplePoint.position.y);

            // Cut gravity off, well before distance threshold.

            if (distance > 500) {
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

    override public function killAll(...rest):void
    {
        super.killAll(rest);
    }

    public function receivedInformation(timeSpent:Number, obj:Object, produced:Number):void
    {
        trace("-> GAME STATE update info "+obj+" and time spent: "+timeSpent);
        _earningsLabel.updateLabel("$"+String(timeSpent));
        _totalProducedLabel.updateLabel("units "+String(Math.round(produced)));

        _scale = timeSpent;
        //_mouse.scaleX = _mouse.scaleY = _scale;
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

