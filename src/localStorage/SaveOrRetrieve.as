/**
 * Created by adm on 31.07.14.
 */
package localStorage {
import flash.data.EncryptedLocalStore;
import flash.utils.ByteArray;

public class SaveOrRetrieve {
    public function SaveOrRetrieve() {
    }

    public static function saveItem(key:String, value:String):void
    {
        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(value);
        EncryptedLocalStore.setItem(key, bytes);
        trace("---------------------------------------------------------------");
        trace("Save in EncryptedLocalStore "+EncryptedLocalStore.isSupported);
        trace("Storeing at key "+key+" -> "+bytes);
        trace("Checking stored item");
        var storedValue:ByteArray = EncryptedLocalStore.getItem(key);
        trace("Check Stored at key"+key+" -> "+storedValue);
        trace("---------------------------------------------------------------");
    }

    public static function  getItem(key:String):String {
        trace("Get from EncryptedLocalStore "+EncryptedLocalStore.isSupported);
        var storedValue:ByteArray = EncryptedLocalStore.getItem(key);
        trace("Stored at key"+key+" -> "+storedValue);
        return(String(storedValue));
    }
}
}
