package game 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Thomas King
	 */
	public class Lift extends Entity
	{
		[Embed(source = '../../assets/sprites/lift_sprite.png')]
		static private var SPRITE_SHEET:Class;
		
		private var targetX:int;
		private var targetY:int;
		private var targetLayer:int;
		private var isOpen:Boolean = true;
		private var isVisible:Boolean = false;
		
		static private var ANIMATION_MAP:Spritemap;
		
		public function Lift(xPos:int, yPos:int, destinationX:int, destinationY:int, destinationLayer:int, lyr:int) 
		{
			if (!ANIMATION_MAP) {
				ANIMATION_MAP = new Spritemap(SPRITE_SHEET, 32, 32);
				ANIMATION_MAP.add("open", [0, 1, 2, 3, 4], 10, false);
				ANIMATION_MAP.add("close", [4, 3, 2, 1, 0], 10, false);
			}
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
			player.x = targetX;
			player.y = targetY - 32;
			player.layer = targetLayer;
		}
		
		public function open():void
		{
			isOpen = true;
			isVisible = true;
			ANIMATION_MAP.play("open");
		}
		
		override public function render():void 
		{
			super.render();
			if (isVisible) {
				ANIMATION_MAP.update();
				ANIMATION_MAP.render(new Point(x, y), FP.camera);
				if (ANIMATION_MAP.complete) {
					if (isOpen) {
						isOpen = false;
						ANIMATION_MAP.play("close");
					}
					else {
						isVisible = false;
					}
				}
			}
		}
		
	}

}