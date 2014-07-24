/**
 * Created by adm on 22.07.2014.
 */
package simulation {
public class Strategy {

    private var linkages:Vector.<Object> = new Vector.<Object>();

    public function Strategy() {
    }

    public function step():void
    {

        for(var i:uint = 0; i<linkages.length; i++)
        {
            if(linkages[i]["via"] != null)
            {
                (linkages[i]["from"] as Producer).produce();
                (linkages[i]["via"] as Transport).doTransport((linkages[i]["from"] as Producer), (linkages[i]["to"] as Producer));
                (linkages[i]["to"] as Producer).produce();
            }
            else
            {
                (linkages[i]["from"] as Producer).produce();
                (linkages[i]["to"] as Transport).resources += (linkages[i]["from"] as Producer).units;
            }
        }
    }

    public function makeNewLinkage(from:BasicSimulation, via:BasicSimulation, to:BasicSimulation):void
    {
        var o:Object = new Object();
        o = {
            from:from,
            via:via,
            to:to
        }

        linkages.push(o)
    }
}
}
