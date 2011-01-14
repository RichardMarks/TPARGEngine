package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Bullet extends Entity
	{
		[Embed(source = '../../assets/sprites/bullet_sprite.png')]
		static private const SPRITE:Class;
		
		private var direction:String;
		
		public function Bullet(xPos:int, yPos:int, lyr:int, dir:String) 
		{
			x = xPos + 12;
			y = yPos + 12;
			layer = lyr;
			direction = dir;
			type = "bullet";
			graphic = new Image(SPRITE);
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