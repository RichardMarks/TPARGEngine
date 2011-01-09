package game
{
	import net.flashpunk.*;
	
	/**
	 * ...
	 * @author Richard Marks
	 */
	public class GameWorld extends World 
	{
		public function GameWorld() { }
		override public function begin():void 
		{
			super.begin();
			add(new Player);
		}
	}
}