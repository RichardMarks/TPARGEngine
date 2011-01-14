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
			setHitbox(8, 8);
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
			
			if (collide("wall", x, y)) {
				var save:Boolean = false;
				var arr:Array = new Array;
				collideInto("floor", x, y + ((9 - layer) / 3 + .25) * 64, arr);
				for each (var ent:Entity in arr) {
					if (ent.layer == 10 && !collide("lift", x, y + ((9 - layer) / 3 + .25) * 64) && !collide("teleport", x, y + ((9 - layer) / 3 + .25) * 64)) {
						save = true;
					}
				}
				if (!save) {
					world.recycle(this);
					return;
				}
			}
		}
		
	}

}