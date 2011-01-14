package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Lift extends Entity
	{
		private var targetX:int;
		private var targetY:int;
		private var targetLayer:int;
		
		public function Lift(xPos:int, yPos:int, destinationX:int, destinationY:int, destinationLayer:int, lyr:int) 
		{
			x = xPos;
			y = yPos;
			setHitbox(32, 32);
			targetX = destinationX;
			targetY = destinationY;
			targetLayer = destinationLayer;
			layer = lyr;
			type = "lift";
		}
		
		public function lift(player:Player):void
		{
			player.x = targetX - 32;
			player.y = targetY - 32;
			player.layer = targetLayer;
		}
		
	}

}