package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Tilemap;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Floor extends Entity
	{
		private var myFloorMap:Tilemap;
		
		public function Floor() { }
		
		static public function load(xml:XML, floor:int, tileset:Class):Floor
		{
			var level:Floor = new Floor;
			
			var tileWidth:int = xml.@tilewidth
			var tileHeight:int = xml.@tileheight;
			
			var columns:int = xml.@width;
			var rows:int = xml.@height;
			
			var width:int = columns * tileWidth;
			var height:int = rows * tileHeight;
			
			level.myFloorMap = new Tilemap(tileset, width, height, tileWidth, tileHeight);
			
			var i:int;
			var xmlData:XML;
			var tileID:int;
			for each (xmlData in xml.layer[1].data.tile) {
				tileID = int (xmlData.@gid) - 1;
				if (tileID >= 0)
				{
					level.myFloorMap.setTile(i % columns, Math.floor(i / columns), tileID);
				}
				i++;
			}
			
			level.graphic = level.myFloorMap;
			level.layer = 10 - floor;
			
			return level;
		}
	}
}