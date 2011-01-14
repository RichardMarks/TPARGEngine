package game
{
	import flash.geom.Point;
	import net.flashpunk.*;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class GameWorld extends World 
	{
		[Embed(source = '../../assets/maps/test1.tmx', mimeType = 'application/octet-stream')]
		private static const TEST_MAP:Class;
		[Embed(source = '../../assets/maps/test2.tmx', mimeType = 'application/octet-stream')]
		private static const TEST_MAP2:Class;
		
		private var targetCameraX:int;
		private var targetCameraY:int;
		
		public function GameWorld() { }
		override public function begin():void 
		{
			super.begin();
			add(Map.loadMap(TEST_MAP));
		}
		
		override public function update():void 
		{
			FP.camera = new Point(targetCameraX, targetCameraY);
			super.update();
		}
		
		public function goto(map:String, playerX:int, playerY:int, playerLayer:int):void
		{
			removeAll();
			if (map == "test1") {
				add(Map.loadMap(TEST_MAP, playerX, playerY, playerLayer));
			}
			else if (map == "test2") {
				add(Map.loadMap(TEST_MAP2, playerX, playerY, playerLayer));
			}
		}
		
		public function setCamera(x:int, y:int):void
		{
			targetCameraX = x;
			targetCameraY = y;
		}
	}
}