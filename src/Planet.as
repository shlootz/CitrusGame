/**
 * Created by adm on 13.08.14.
 */
package {
import citrus.objects.NapePhysicsObject;

import nape.geom.AABB;

import nape.geom.GeomPoly;

import nape.geom.GeomPolyList;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

public class Planet extends NapePhysicsObject {
    public function Planet(name:String, params:Object = null) {
        super(name, params)
    }

    override protected function createBody():void {
        super.createBody();
        // Create the central planet.
        var w:uint = 800;
        var h:uint = 480;

        var planet:Body = new Body(BodyType.STATIC);
        var polys:GeomPolyList = MarchingSquares.run(
                new StarIso(),
                new AABB(0, 0, w, h),
                new Vec2(5, 5)
        );
        for (var i:int = 0; i < polys.length; i++) {
            var poly:GeomPoly = polys.at(i);
            var convexPolys:GeomPolyList = poly.simplify(1).convexDecomposition(true);
            for (var j:int = 0; j < convexPolys.length; j++) {
                var p:GeomPoly = convexPolys.at(j);
                planet.shapes.add(new Polygon(p));
            }
        }
        _body = planet;
    }
}
}

import nape.geom.IsoFunction;

class StarIso implements IsoFunction {
    public function StarIso():void {}
    public function iso(x:Number, y:Number):Number {
        x -= 400;
        y -= 300;
        return 7000 * Math.sin(5 * Math.atan2(y, x)) + x * x + y * y - 150*150;
    }
}
