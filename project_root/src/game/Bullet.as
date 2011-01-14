package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Bullet extends Entity
	{
		private var direction:String;
		
		public function Bullet(xPos:int, yPos:int, lyr:int, dir:String) 
		{
			x = xPos;
			y = yPos;
			layer = lyr;
			direction = dir;
			type = "bullet";
		}
		
		static private var SPEED:int = 256;
		override public function update():void 
		{
			super.update();
			if (direction == "north") {
				y -= SPEED * FP.elapsed;
			}
			else if (direction == "south") {
				y += SPEED * FP.elapsed;
			}
			else if (direction == "east") {
				x += SPEED * FP.elapsed;
			}
			else if (direction == "west") {
				x -= SPEED * FP.elapsed;
			}
		}
		
	}

}