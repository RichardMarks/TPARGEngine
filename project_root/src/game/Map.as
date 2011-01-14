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
		
		static public function loadMap(data:Class, playerX:int = -1, playerY:int = -1, playerLayer:int = -1):Map
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
			
			if (playerX > 0) {
				FP.world.add(new Player(playerX, playerY, playerLayer));
			}
			i = 0;
			var xmlList:XML;
			for each (xmlList in xml.objectgroup) {
				for each (xmlData in xmlList.object) {
					if (xmlData.@type == "player_start" && playerX < 0) {
						var xPos:int = Math.floor(xmlData.@x / 32) * 32;
						var yPos:int = Math.floor(xmlData.@y / 32) * 32;
						FP.world.add(new Player(xPos, yPos, 9 - i * 2));
					}
					else if (xmlData.@type == "map_change") {
						xPos = Math.floor(xmlData.@x / 32) * 32;
						yPos = Math.floor(xmlData.@y / 32) * 32;
						for each (var property:XML in xmlData.properties.property) {
							if (property.@name == "destinationX") {
								var targetX:int = property.@value * 32;
							}
							else if (property.@name == "destinationY") {
								var targetY:int = property.@value * 32;
							}
							else if (property.@name == "destinationMap") {
								var targetMap:String = property.@value;
							}
							else if (property.@name == "destinationFloor") {
								var targetLayer:int = 9 - (property.@value - 1) * 2;
							}
						}
						FP.world.add(new Teleport(xPos, yPos, targetMap, targetX, targetY, targetLayer, 10 - i * 2));
					}
					else if (xmlData.@type == "floor_change") {
						xPos = Math.floor(xmlData.@x / 32) * 32;
						yPos = Math.floor(xmlData.@y / 32) * 32;
						for each (property in xmlData.properties.property) {
							if (property.@name == "destinationX") {
								targetX = property.@value * 32;
							}
							else if (property.@name == "destinationY") {
								targetY = property.@value * 32;
							}
							else if (property.@name == "destinationFloor") {
								targetLayer = 9 - (property.@value - 1) * 2;
							}
						}
						FP.world.add(new Lift(xPos, yPos, targetX, targetY, targetLayer, 10 - i * 2));
					}
				}
				i++;
			}
			
			map.graphic = map.myWallMap;
			map.layer = 11;
			
			return map;
		}
		
	}

}