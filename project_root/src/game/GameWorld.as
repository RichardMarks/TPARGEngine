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
			add(new Player);
			add(Map.loadMap(TEST_MAP));
		}
	}
}