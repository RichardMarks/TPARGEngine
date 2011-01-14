package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Terminal extends Entity
	{
		[Embed(source = '../../assets/sprites/terminal_sprite.png')]
		static private const SPRITE:Class;
		
		public var maxAccess:int;
		
		public function Terminal(xPos:int, yPos:int, lyr:int, accessLevel:int) 
		{
			x = xPos;
			y = yPos;
			layer = lyr;
			maxAccess = accessLevel;
			
			setHitbox(32, 32);
			type = "terminal";
			
			graphic = new Image(SPRITE);
		}
		
	}

}