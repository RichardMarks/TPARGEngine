package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Floor extends Entity
	{
		private var myFloorMap:Tilemap;
		private var myFringeMap:Tilemap;
		
		private var myGridMask:Grid;
		
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
			level.myFringeMap = new Tilemap(tileset, width, height, tileWidth, tileHeight);
			level.myGridMask = new Grid(width, height, tileWidth, tileHeight);
			level.myGridMask.usePositions = false;
			
			var i:int;
			var xmlData:XML;
			var tileID:int;
			for each (xmlData in xml.layer[floor * 3 + 1].data.tile) {
				tileID = int (xmlData.@gid) - 1;
				if (tileID >= 0)
				{
					level.myFloorMap.setTile(i % columns, Math.floor(i / columns), tileID);
					level.myGridMask.setCell(i % columns, Math.floor(i / columns));
				}
				i++;
			}
			i = 0;
			for each (xmlData in xml.layer[floor * 3 + 2].data.tile) {
				tileID = int (xmlData.@gid) - 1;
				if (tileID >= 0)
				{
					level.myFringeMap.setTile(i % columns, Math.floor(i / columns), tileID);
				}
				i++;
			}
			
			var graphic:Graphiclist = new Graphiclist(level.myFloorMap, level.myFringeMap);
			level.graphic = graphic;
			level.layer = 10 - floor * 3;
			level.type = "floor";
			level.mask = level.myGridMask;
			
			return level;
		}
	}
}