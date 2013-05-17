package flambe;
import flambe.Entity;
import flambe.math.Matrix;
import flambe.display.Sprite;
using Reflect;
/**
 * ...
 * @author ...
 */
class EntityHelper
{

	public  static function applychildsProperty(owner:Entity, filed:String, value:Dynamic) {
			
		var child :Entity= owner.firstChild;
      while (child != null) {
      var next = child.next; // Store in case the child is removed in process()
	 
     child.firstComponent.setField(filed, value);
      child = next;
	  }
		
		}
		
		
	
}