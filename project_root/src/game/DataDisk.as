package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class DataDisk extends Entity
	{
		[Embed(source = '../../assets/sprites/disk_sprite.png')]
		static private const SPRITE:Class;
		
		static public var COLLECTED:String = "";
		
		private var id:int;
		
		public function DataDisk(xPos:int, yPos:int, lyr:int, idNum:int) 
		{
			x = xPos + 8;
			y = yPos + 8;
			layer = lyr;
			id = idNum;
			
			graphic = new Image(SPRITE);
			
			type = "disk";
			
			while (COLLECTED.length - 1 < idNum) {
				COLLECTED += "o";
			}
		}
		
		public function collect():void
		{
			COLLECTED = COLLECTED.substring(0, id) + "f" + COLLECTED.substring(id + 1);
			world.recycle(this);
		}
		
	}

}