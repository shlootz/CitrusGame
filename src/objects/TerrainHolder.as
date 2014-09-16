/**
 * Created by adm on 08.09.14.
 */
package objects {
import citrus.objects.NapePhysicsObject;
import citrus.physics.nape.Nape;

import flash.display.BitmapData;
import flash.display.BitmapDataChannel;

import nape.callbacks.InteractionCallback;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.geom.AABB;

public class TerrainHolder extends NapePhysicsObject{

    private var _na:Nape;
    public function TerrainHolder(na:Nape) {
        super("TerrainHolder");
        _na = na;

        makeTerrain();
    }

    private var terrain:Terrain;
    private function makeTerrain():void
    {
        // Initialise terrain bitmap.
        var bit:BitmapData = new BitmapData(800, 600, true, 0);
        bit.perlinNoise(200, 200, 2, 0x3ed, false, true, BitmapDataChannel.ALPHA, false);

        // Create initial terrain state, invalidating the whole screen.
        terrain = new Terrain(bit, 30, 5);
        terrain.invalidate(new AABB(0, 0, 800, 600), _na.space);
    }

    override public function handlePreContact(callback:PreCallback):PreFlag
    {
       return super.handlePreContact(callback);
    }

    override public function handleBeginContact(callback:InteractionCallback):void
    {
        super.handleBeginContact(callback)
    }

    override public function handleEndContact(callback:InteractionCallback):void
    {
        super.handleEndContact(callback)
    }
}
}
