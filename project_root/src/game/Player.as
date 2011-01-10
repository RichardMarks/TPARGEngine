package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * player class
	 * @author Thomas King
	 */
	public class Player extends Entity
	{
		[Embed(source = '../../assets/sprites/player-spritesheet.png')]
		static private const PLAYER_SPRITE_SHEET:Class;
		
		private var mySpritemap:Spritemap;
		
		static private const FRAME_WIDTH:int = 32;
		static private const FRAME_HEIGHT:int = 32;
		
		private var myLastDirection:String = "north";
		
		public var hasGun:Boolean;
		
		public function Player() { }
		
		private var targetX:Number;
		private var targetY:Number;
		
		override public function added():void 
		{
			super.added();
			
			// set position to somewhere towards the middle of the screen
			x = 320;
			y = 320;
			targetX = x;
			targetY = y;
			
			mySpritemap = new Spritemap(PLAYER_SPRITE_SHEET, FRAME_WIDTH, FRAME_HEIGHT);
			
			graphic = mySpritemap;
			layer = 9;
			setHitbox(FRAME_WIDTH, FRAME_HEIGHT);
			
			// set the animations on the sprite sheet
			mySpritemap.add("north idle", [0]);
			mySpritemap.add("north walk", [1, 0, 2, 0], 10, true);
			mySpritemap.add("north jump", [6]);
			mySpritemap.add("north land", [7, 0], 5, false);
			mySpritemap.add("north climb idle", [8]);
			mySpritemap.add("north climb", [9, 8], 7, true);
			mySpritemap.add("north death", [10, 11], 5, false);
			
			mySpritemap.add("south idle", [0]);
			mySpritemap.add("south walk", [1, 0, 2, 0], 10, true);
			mySpritemap.add("south jump", [6]);
			mySpritemap.add("south land", [7, 0], 5, false);
			mySpritemap.add("south climb idle", [8]);
			mySpritemap.add("south climb", [9, 8], 7, true);
			mySpritemap.add("south death", [10, 11], 5, false);
			
			mySpritemap.add("east idle", [24]);
			mySpritemap.add("east walk", [25, 24, 26, 24], 10, true);
			mySpritemap.add("east jump", [30]);
			mySpritemap.add("east land", [31, 24], 5, false);
			mySpritemap.add("east climb idle", [32]);
			mySpritemap.add("east climb", [33, 32], 7, true);
			mySpritemap.add("east death", [34, 35], 5, false);
			
			mySpritemap.add("west idle", [36]);
			mySpritemap.add("west walk", [37, 36, 38, 36], 10, true);
			mySpritemap.add("west jump", [42]);
			mySpritemap.add("west land", [43, 36], 5, false);
			mySpritemap.add("west climb idle", [44]);
			mySpritemap.add("west climb", [45, 44], 7, true);
			mySpritemap.add("west death", [46, 47], 5, false);
			
			// set default animation to north/south idle
			mySpritemap.play("north idle");
			
			Input.define("walk north", Key.W, Key.UP);
			Input.define("walk south", Key.S, Key.DOWN);
			Input.define("walk east", Key.D, Key.RIGHT);
			Input.define("walk west", Key.A, Key.LEFT);
			Input.define("jump", Key.SPACE);
			Input.define("climb", Key.C);
			Input.define("climb up", Key.W, Key.UP);
			Input.define("climb down", Key.S, Key.DOWN);
			Input.define("kill", Key.K); // temporary kill button to test death animations
		}
		
		private var isMoving:Boolean = false;
		private const SPEED:Number = 64;
		private var isJumping:Boolean = false;
		private var isClimbing:Boolean = false;
		private var timeForMove:Number = .1;
		private var timeSinceMove:Number = .1;
		override public function update():void 
		{
			super.update();
			timeSinceMove += FP.elapsed;
			if (x - FP.camera.x > 496) {
				FP.camera.x = x - 496;
			}
			else if (x - FP.camera.x < 304) {
				FP.camera.x = x - 304;
			}
			if (y - FP.camera.y > 396) {
				FP.camera.y = y - 396;
			}
			else if (y - FP.camera.y < 204) {
				FP.camera.y = y - 204;
			}
			if (!isMoving) {
				if (Input.pressed("climb"))
				{
					isClimbing = !isClimbing;
					if (isClimbing)
					{
						mySpritemap.play(myLastDirection + " climb idle");
					}
					else
					{
						mySpritemap.play(myLastDirection + " idle");
					}
				}
				if (!isClimbing)
				{
					if (Input.check("walk north"))
					{
						if (myLastDirection == "north")
						{
							if (timeSinceMove > timeForMove)
							{
								var entities:Array = new Array;
								collideInto("floor", x, y - FRAME_HEIGHT, entities);
								for each (var ent:Entity in entities)
								{
									if (ent.layer == layer + 1)
									{
										mySpritemap.play("north walk", false);
										targetY -= FRAME_HEIGHT;
										isMoving = true;
									}
								}
							}
						}
						else
						{
							myLastDirection = "north";
							mySpritemap.play("north idle", false);
							timeSinceMove = 0;
						}
					}
					else if (Input.check("walk south"))
					{
						if (myLastDirection == "south")
						{
							if (timeSinceMove > timeForMove)
							{
								entities = new Array;
								collideInto("floor", x, y + FRAME_HEIGHT, entities);
								for each (ent in entities)
								{
									if (ent.layer == layer + 1)
									{
										mySpritemap.play("south walk", false);
										targetY += FRAME_HEIGHT;
										isMoving = true;
									}
								}
							}
						}
						else
						{
							myLastDirection = "south";
							mySpritemap.play("south idle");
							timeSinceMove = 0;
						}
					}
					else if (Input.check("walk east"))
					{
						if (myLastDirection == "east")
						{
							if (timeSinceMove > timeForMove)
							{
								entities = new Array;
								collideInto("floor", x + FRAME_WIDTH, y, entities);
								for each (ent in entities)
								{
									if (ent.layer == layer + 1)
									{
										mySpritemap.play("east walk", false);
										targetX += FRAME_WIDTH;
										isMoving = true;
									}
								}
							}
						}
						else
						{
							myLastDirection = "east";
							mySpritemap.play("east idle");
							timeSinceMove = 0;
						}
					}
					else if (Input.check("walk west"))
					{
						if (myLastDirection == "west")
						{
							if (timeSinceMove > timeForMove)
							{
								entities = new Array;
								collideInto("floor", x - FRAME_WIDTH, y, entities);
								for each (ent in entities)
								{
									if (ent.layer == layer + 1)
									{
										mySpritemap.play("west walk", false);
										targetX -= FRAME_WIDTH;
										isMoving = true;
									}
								}
							}
						}
						else
						{
							myLastDirection = "west";
							mySpritemap.play("west idle");
							timeSinceMove = 0;
						}
					}
					else if (Input.pressed("jump"))
					{
						isMoving = true;
						isJumping = true;
						mySpritemap.play(myLastDirection + " jump")
						if (myLastDirection == "north")
						{
							targetY -= FRAME_HEIGHT * 2;
						}
						else if (myLastDirection == "south")
						{
							targetY += FRAME_HEIGHT * 2;
						}
						else if (myLastDirection == "east")
						{
							targetX += FRAME_WIDTH * 2;
						}
						else
						{
							targetX -= FRAME_WIDTH * 2;
						}
					}
					// temporary to check death animation
					else if (Input.pressed("kill"))
					{
						mySpritemap.play(myLastDirection + " death");
					}
				}
				else
				{
					if (Input.check("climb up"))
					{
						mySpritemap.play(myLastDirection + " climb");
						targetY -= FRAME_HEIGHT;
						isMoving = true;
						layer -= 2;
					}
					else if (Input.check("climb down"))
					{
						mySpritemap.play(myLastDirection + " climb");
						targetY += FRAME_HEIGHT;
						isMoving = true;
						layer += 2;
					}
				}
			}
			else
			{
				if (targetX != x)
				{
					var dx:Number;
					if (targetX < x)
					{
						dx = Math.max( -SPEED * FP.elapsed, targetX - x);
					}
					else
					{
						dx = Math.min(SPEED * FP.elapsed, targetX - x);
					}
					x += dx;
				}
				else if (targetY != y)
				{
					var dy:Number;
					if (targetY < y)
					{
						dy = Math.max( -SPEED * FP.elapsed, targetY - y);
					}
					else
					{
						dy = Math.min(SPEED * FP.elapsed, targetY - y);
					}
					y += dy;
				}
				else
				{
					isMoving = false;
					if (isJumping)
					{
						mySpritemap.play(myLastDirection + " land");
						isJumping = false;
					}
					else if (isClimbing)
					{
						mySpritemap.play(myLastDirection + " climb idle");
					}
					else
					{
						mySpritemap.play(myLastDirection + " idle");
					}
				}
			}
		}
	}
}