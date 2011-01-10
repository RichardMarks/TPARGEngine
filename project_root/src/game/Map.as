package game 
{
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Map extends Entity
	{
		private var myFloors:Vector.<Floor>;
		private var myCurrentFloor:int;
		
		public function Map() 
		{
			myFloors = new Vector.<Floor>();
		}
		
		static public function loadMap(data:Class):Map
		{
			var map:Map = new Map;
			
			var file:ByteArray = new data;
			var str:String = file.readUTFBytes(file.length);
			var xml:XML = new XML(str);
			
			map.myFloors.push(Floor.load(xml, 1));
			
			return map;
		}
		
	}

}