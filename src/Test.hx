package ;
import de.polygonal.ds.ResettableIterator;
import de.polygonal.ds.ArrayConvert;
import de.polygonal.ds.Compare;
import de.polygonal.ds.DA;
import de.polygonal.ds.ListSet;
import de.polygonal.ds.SLL;
import de.polygonal.ds.SLLNode;

/**
 * ...
 * @author sonygod
 */
class Test
{

	public function new() 
	{
		
	}
	
	 private static function main() {
		 
		 
		 var l :SLL<Int>= new SLL<Int>();
		l.append(1);
		l.append(0);
		l.sort(Compare.compareNumberRise, true);

         l.insertAfter(l.nodeOf(1),2);
         var itr:ResettableIterator<Int> = l.iterator();

         for(i in itr){
            trace(i);
         }
		
		
		
		
	 }
	
}