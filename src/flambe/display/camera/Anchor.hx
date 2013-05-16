package flambe.display.camera;

/**
 * ...
 * @author ...
 */
class Anchor
{
        public static var centerLeft	:Anchor = make(0  , 0.5);
		public static var centerRight	:Anchor = make(1  , 0.5);
		public static var center		:Anchor = make(0.5, 0.5);
		public static var topLeft		:Anchor = make(0  , 0  );
		public static var topRight	:Anchor = make(1  , 0  );
		public static var topCenter	:Anchor = make(0.5, 0  );
		public static var bottomLeft	:Anchor = make(0  , 1  );
		public static var bottomRight	:Anchor = make(1  , 1  );
		public static var bottomCenter:Anchor = make(0.5, 1  );
	
		@:isVar public var u(get, null) :Float ;
		@:isVar public var v(get, null) :Float ;
		
		private var _u:Float;
		private var _v:Float;
	
	public function new(u:Float,v:Float) 
	{
		_u = u;
		_v = v;
	}
	
	
	 private function get_u() : Float
		{
			return _u;
		}
		
		private function get_v() : Float
		{
			return _v;
		}
    
		private static function make(u:Float,v:Float):Anchor
		{
			return new Anchor(u,v); 
		}
}