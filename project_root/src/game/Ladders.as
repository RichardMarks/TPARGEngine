package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Ladders extends Entity
	{
		private var myLadderMap:Tilemap;
		private var myGridMask:Grid;
		
		public function Ladders() { }
		
		static public function load(xml:XML, floor:int, tileset:Class):Ladders
		{
			var level:Ladders = new Ladders;
			
			var tileWidth:int = xml.@tilewidth
			var tileHeight:int = xml.@tileheight;
			
			var columns:int = xml.@width;
			var rows:int = xml.@height;
			
			var width:int = columns * tileWidth;
			var height:int = rows * tileHeight;
			
			level.myLadderMap = new Tilemap(tileset, width, height, tileWidth, tileHeight);
			level.myGridMask = new Grid(width, height, tileWidth, tileHeight);
			level.myGridMask.usePositions = false;
			
			var i:int;
			var xmlData:XML;
			var tileID:int;
			for each (xmlData in xml.layer[floor * 3 + 3].data.tile) {
				tileID = int (xmlData.@gid) - 1;
				if (tileID >= 0)
				{
					level.myLadderMap.setTile(i % columns, Math.floor(i / columns), tileID);
					level.myGridMask.setCell(i % columns, Math.floor(i / columns));
				}
				i++;
			}
			
			level.graphic = level.myLadderMap;
			level.layer = 10 - floor * 2;
			level.type = "ladder";
			level.mask = level.myGridMask;
			
			return level;
		}
	}

}