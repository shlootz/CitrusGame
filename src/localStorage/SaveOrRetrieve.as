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
    }

    public static function  getItem(key:String):ByteArray {
        var storedValue:ByteArray = EncryptedLocalStore.getItem(key);
        //
        return storedValue
    }
}
}
