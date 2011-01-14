package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Teleport extends Entity
	{
		private var targetMap:String;
		private var targetX:int;
		private var targetY:int;
		private var targetLayer:int;
		
		public function Teleport(xPos:int, yPos:int, destinationMap:String, destinationX:int, destinationY:int, destinationLayer:int, lyr:int) 
		{
			x = xPos;
			y = yPos;
			setHitbox(32, 32);
			targetMap = destinationMap;
			targetX = destinationX;
			targetY = destinationY;
			targetLayer = destinationLayer;
			layer = lyr;
			type = "teleport";
		}
		
		public function teleport():void
		{
			(FP.world as GameWorld).goto(targetMap, targetX, targetY, targetLayer);
		}
		
	}

}