/**
 * Created by adm on 12.08.14.
 */
package {
import citrus.physics.nape.Nape;

public class MyNape extends Nape{
    public function MyNape(name:String = "myName") {
        this.updateCallEnabled = true;
        super(name);
    }

    override  public function  update(deltaTime:Number):void
    {
        trace("UPDATE");
        super.update(deltaTime);
    }
}
}
