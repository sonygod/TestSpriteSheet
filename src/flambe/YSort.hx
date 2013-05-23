package flambe;
using Reflect;
/**
 * ...
 * @author ...
 */
class YSort
{

	public static function yShot(l:Entity) {
		
		
	 var  p :Entity= l;    //p,q用来维护插入位置的前后指针  
     var q :Entity= l.next;  
     var r:Entity = q;    //r,s用来维护当前带插入的前后指针  
     var  s :Entity= r.next;  
        while(s!=null)  
        {  
            while( s.firstComponent.field("y") > q.firstComponent.field("y"))  //如果q != s, p,q下移  
            {  
                p = p.next;  
                q = q.next;  
            }  
            if(q.firstComponent.field("y")==s.firstComponent.field("y"))   //当跳出的循环条件是q == s时，说明s比前面的都大,不用插入  
            {  
                p = l;  
                q = l.next;  
                r = r.next;  
                s = s.next;  
            }  
            else            //当跳出的条件是s.data > q.data时，  
            {  
                //这是交换节点
				r.setField("next",s.next);  
                s.setField("next", q);  
                p.setField("next",s);  
                //让s指向它原先的下一个，继续进行这个过程  
                s = r.next;  
                //让p,q回到起始位置，以便下一个插入时从头进行比较  
                p = l;  
                q = l.next;  
            }  
        }
		
	}
	
	
	
}