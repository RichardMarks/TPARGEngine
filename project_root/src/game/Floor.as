package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Floor extends Entity
	{
		[Embed(source='../../assets/tiles/basic_tiles.png')]
		static private const TILESET:Class;
		
		private var myFloorMap:Tilemap;
		private var myWallMap:Tilemap;
		
		public function Floor() { }
		
		static public function load(xml:XML, floor:int):Floor
		{
			var level:Floor = new Floor;
			
			var tileWidth:int = xml.map.@tilewidth
			var tileHeight:int = xml.map.@tileheight;
			var width:int = xml.map.@width * tileWidth;
			var height:int = xml.map.@height * tileHeight;
			level.myFloorMap = new Tilemap(TILESET, width, height, tileWidth, tileHeight);
			level.myWallMap = new Tilemap(TILESET, width, height, tileWidth, tileHeight);
			
			return level;
		}
		
	}

}