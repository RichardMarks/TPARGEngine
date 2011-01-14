package game 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class KeyCard extends Entity
	{
		static public var FOUND:Boolean;
		
		public function KeyCard(xPos:int, yPos:int, lyr:int) 
		{
			x = xPos + 8;
			y = yPos + 8;
			
			layer = lyr;
			
			graphic = new Image(new BitmapData(16, 16, false, 0xFF00FF));
			type = "keycard";
		}
		
	}

}