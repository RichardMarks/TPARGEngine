package game
{
	import net.flashpunk.*;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class GameWorld extends World 
	{
		[Embed(source = '../../assets/maps/r1.tmx', mimeType = 'application/octet-stream')]
		private static const TEST_MAP:Class;
		
		public function GameWorld() { }
		override public function begin():void 
		{
			super.begin();
			add(Map.loadMap(TEST_MAP));
		}
		
		public function goto(map:String, playerX:int, playerY:int, playerLayer:int)
		{
			removeAll();
			if (map == "test1") {
				add(Map.loadMap(TEST_MAP, playerX, playerY, playerLayer));
			}
			else if (map == "test2") {
				add(Map.loadMap(TEST_MAP2, playerX, playerY, playerLayer));
			}
		}
	}
}