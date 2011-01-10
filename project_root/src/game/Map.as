package game 
{
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Tilemap;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Map extends Entity
	{
		[Embed(source='../../assets/tiles/basic_tiles.png')]
		static private const TILESET:Class;
		
		private var myFloors:Vector.<Floor>;
		private var myCurrentFloor:int;
		
		private var myWallMap:Tilemap
		
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
			
			var tileWidth:int = xml.@tilewidth
			var tileHeight:int = xml.@tileheight;
			
			var columns:int = xml.@width;
			var rows:int = xml.@height;
			
			var width:int = columns * tileWidth;
			var height:int = rows * tileHeight;
			
			map.myWallMap = new Tilemap(TILESET, width, height, tileWidth, tileHeight);
			
			var i:int;
			var xmlData:XML;
			var tileID:int;
			for each (xmlData in xml.layer[0].data.tile) {
				tileID = int (xmlData.@gid) - 1;
				if (tileID >= 0)
				{
					map.myWallMap.setTile(i % columns, Math.floor(i / columns), tileID);
				}
				i++;
			}
			
			map.myFloors.push(Floor.load(xml, 0, TILESET));
			map.myFloors.push(Floor.load(xml, 1, TILESET));
			map.myFloors.push(Floor.load(xml, 2, TILESET));
			
			var floor:Floor;
			for each (floor in map.myFloors) {
				FP.world.add(floor);
			}
			
			FP.world.add(Ladders.load(xml, 0, TILESET));
			FP.world.add(Ladders.load(xml, 1, TILESET));
			FP.world.add(Ladders.load(xml, 2, TILESET));
			
			map.graphic = map.myWallMap;
			map.layer = 11;
			
			return map;
		}
		
	}

}