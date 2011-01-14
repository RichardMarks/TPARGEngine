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
	public class Teleport extends Entity
	{
		[Embed(source = '../../assets/sprites/exit_sprite.png')]
		static private var SPRITE_SHEET:Class;
		
		private var targetX:int;
		private var targetY:int;
		private var targetLayer:int;
		private var targetMap:String;
		private var isOpen:Boolean = true;
		private var wasOpened:Boolean = false;
		private var isVisible:Boolean = false;
		public var accessLevel:int;
		static public var targetPlayer:Player;
		
		private var animationMap:Spritemap;
		
		public function Teleport(xPos:int, yPos:int, destinationMap:String, destinationX:int, destinationY:int, destinationLayer:int, lyr:int, player:Player) 
		{
			animationMap = new Spritemap(SPRITE_SHEET, 32, 32);
			animationMap.add("idle", [0]);
			animationMap.add("open", [0, 1, 2, 3, 4], 40, false);
			animationMap.add("close", [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 40, false);
			animationMap.play("idle");
			graphic = animationMap;
			x = xPos;
			y = yPos;
			setHitbox(32, 32);
			targetX = destinationX;
			targetY = destinationY;
			targetLayer = destinationLayer;
			targetMap = destinationMap;
			layer = lyr;
			type = "teleport";
		}
		
		public function open(isPlayer:Boolean = true):void
		{
			wasOpened = isPlayer
			isOpen = true;
			isVisible = true;
			animationMap.play("open");
		}
		
		override public function update():void 
		{
			super.update();
			if (animationMap.complete && animationMap.currentAnim != "idle") {
				if (isOpen) {
					if (!wasOpened) {
						targetPlayer.moveTo(x, y + 32);
					}
					isOpen = false;
					animationMap.play("close");
				}
				else {
					if (wasOpened) {
						animationMap.play("idle");
						targetPlayer.x = targetX;
						targetPlayer.y = targetY - 32;
						targetPlayer.layer = targetLayer;
						(FP.world as GameWorld).goto(targetMap, targetX, targetY - 32, targetLayer);
						targetPlayer.moveTo(targetX, targetY - 32);
						wasOpened = false;
					}
				}
			}
		}
		
	}

}