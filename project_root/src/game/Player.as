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
		
		private var myLastDirection:String = "south";
		
		public var myKeyCards:int = 0;
		
		public var hasGun:Boolean;
		
		public function Player(xPos:int, yPos:int, startLayer:int) 
		{
			x = xPos;
			y = yPos;
			layer = startLayer;
		}
		
		private var targetX:Number;
		private var targetY:Number;
		private var targetLayer:int;
		
		override public function added():void 
		{
			super.added();
			
			// set position to somewhere towards the middle of the screen
			targetX = x;
			targetY = y;
			targetLayer = layer;
			
			mySpritemap = new Spritemap(PLAYER_SPRITE_SHEET, FRAME_WIDTH, FRAME_HEIGHT);
			
			graphic = mySpritemap;
			type = "player";
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
			mySpritemap.play("south idle");
			
			Input.define("walk north", Key.W, Key.UP);
			Input.define("walk south", Key.S, Key.DOWN);
			Input.define("walk east", Key.D, Key.RIGHT);
			Input.define("walk west", Key.A, Key.LEFT);
			Input.define("jump", Key.SPACE);
			Input.define("climb", Key.C);
			Input.define("climb up", Key.W, Key.UP);
			Input.define("climb down", Key.S, Key.DOWN);
			Input.define("kill", Key.K); // temporary kill button to test death animations
			
			Lift.targetPlayer = this;
			Teleport.targetPlayer = this;
		}
		
		public function moveTo(x:int, y:int):void
		{
			targetX = x;
			targetY = y;
			isMoving = true;
			myLastDirection = "south";
			mySpritemap.play(myLastDirection + " walk");
		}
		
		private var isMoving:Boolean = false;
		private const SPEED:Number = 64;
		private var isJumping:Boolean = false;
		private var isClimbing:Boolean = false;
		private var timeForMove:Number = .1;
		private var timeSinceMove:Number = .1;
		private var entities:Array = new Array;
		private var move:Boolean = true;
		override public function update():void 
		{
			super.update();
			timeSinceMove += FP.elapsed;
			var tx:int = FP.camera.x;
			var ty:int = FP.camera.y;
			if (x - FP.camera.x > 496) {
				tx = x - 496
			}
			else if (x - FP.camera.x < 304) {
				tx = x - 304;
			}
			if (y - FP.camera.y > 396) {
				ty = y - 396;
			}
			else if (y - FP.camera.y < 204) {
				ty = y - 204;
			}
			(FP.world as GameWorld).setCamera(tx, ty);
			if (!isMoving) {
				if (myKeyCards < 1) {
					var tempEnt:Entity = collide("keycard", x, y);
					if (tempEnt && tempEnt.layer == layer) {
						world.recycle(tempEnt);
						myKeyCards = 1;
					}
				}
				if (Input.pressed("climb"))
				{
					entities.length = 0;
					collideInto("ladder", x, y, entities);
					for each (var ent:Entity in entities)
					{
						if (ent.layer == layer + 1)
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
								entities.length = 0;
								collideInto("floor", x, y - FRAME_HEIGHT, entities);
								for each (ent in entities)
								{
									if (ent.layer == layer + 1)
									{
										move = true;
										entities.length = 0;
										collideInto("ladder", x, y, entities);
										for each (ent in entities)
										{
											if (ent.layer == layer + 1)
											{
												entities.length = 0;
												collideInto("ladder", x, y - FRAME_HEIGHT, entities);
												for each (ent in entities)
												{
													if (ent.layer == layer - 2)
													{
														move = false;
													}
												}
											}
										}
										if (move)
										{
											var lift:Lift = collide("lift", x, y - 32) as Lift;
											if (lift && lift.layer == layer - 1)
											{
												lift.open();
											}
											var tele:Teleport = collide("teleport", x, y - 32) as Teleport;
											if (tele && tele.layer == layer - 1)
											{
												if (myKeyCards >= tele.accessLevel) {
													tele.open();
												}
												else {
													move = false;
												}
											}
											if (move) {
												mySpritemap.play("north walk", false);
												targetY -= FRAME_HEIGHT;
												isMoving = true;
											}
										}
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
								entities.length = 0;
								collideInto("floor", x, y + FRAME_HEIGHT, entities);
								for each (ent in entities)
								{
									if (ent.layer == layer + 1)
									{
										move = true;
										entities.length = 0;
										collideInto("ladder", x, y + FRAME_HEIGHT, entities);
										for each (ent in entities)
										{
											if (ent.layer == layer + 1)
											{
												move = false;
												entities.length = 0;
												collideInto("ladder", x, y + FRAME_HEIGHT * 2, entities);
												for each (ent in entities)
												{
													if (ent.layer == layer + 1)
													{
														move = true;
													}
												}
											}
										}
										if (move)
										{
											mySpritemap.play("south walk", false);
											targetY += FRAME_HEIGHT;
											isMoving = true;
										}
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
								entities.length = 0;
								collideInto("floor", x + FRAME_WIDTH, y, entities);
								for each (ent in entities)
								{
									if (ent.layer == layer + 1)
									{
										entities.length = 0;
										collideInto("ladder", x + FRAME_WIDTH, y, entities);
										move = true;
										for each (ent in entities)
										{
											if (ent.layer == layer + 1)
											{
												move = false;
											}
										}
										if (move) {
											mySpritemap.play("east walk", false);
											targetX += FRAME_WIDTH;
											isMoving = true;
										}
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
								entities.length = 0;
								collideInto("floor", x - FRAME_WIDTH, y, entities);
								for each (ent in entities)
								{
									if (ent.layer == layer + 1)
									{
										entities.length = 0;
										collideInto("ladder", x - FRAME_WIDTH, y, entities);
										move = true;
										for each (ent in entities)
										{
											if (ent.layer == layer + 1)
											{
												move = false;
											}
										}
										if (move) {
											mySpritemap.play("west walk", false);
											targetX -= FRAME_WIDTH;
											isMoving = true;
										}
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
						if (myLastDirection == "north")
						{
							entities.length = 0;
							collideInto("floor", x, y - FRAME_HEIGHT * 2, entities);
							for each (ent in entities)
							{
								if (ent.layer == layer + 1)
								{
									targetY -= FRAME_HEIGHT * 2;
									isMoving = true;
									isJumping = true;
									mySpritemap.play(myLastDirection + " jump");
								}
							}
						}
						else if (myLastDirection == "south")
						{
							entities.length = 0;
							collideInto("floor", x, y + FRAME_HEIGHT * 2, entities);
							for each (ent in entities)
							{
								if (ent.layer == layer + 1)
								{
									targetY += FRAME_HEIGHT * 2;
									isMoving = true;
									isJumping = true;
									mySpritemap.play(myLastDirection + " jump");
								}
							}
						}
						else if (myLastDirection == "east")
						{
							entities.length = 0;
							collideInto("floor", x + FRAME_WIDTH * 2, y, entities);
							for each (ent in entities)
							{
								if (ent.layer == layer + 1)
								{
									targetX += FRAME_WIDTH * 2;
									isMoving = true;
									isJumping = true;
									mySpritemap.play(myLastDirection + " jump");
								}
							}
						}
						else
						{
							entities.length = 0;
							collideInto("floor", x - FRAME_WIDTH * 2, y, entities);
							for each (ent in entities)
							{
								if (ent.layer == layer + 1)
								{
									targetX -= FRAME_WIDTH * 2;
									isMoving = true;
									isJumping = true;
									mySpritemap.play(myLastDirection + " jump");
								}
							}
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
						entities.length = 0;
						collideInto("ladder", x, y - FRAME_HEIGHT, entities);
						for each (ent in entities)
						{
							if (ent.layer == layer - 2)
							{
								mySpritemap.play(myLastDirection + " climb");
								targetY -= FRAME_HEIGHT * 2;
								isMoving = true;
								layer -= 3;
								targetLayer = layer;
							}
						}
					}
					else if (Input.check("climb down"))
					{
						entities.length = 0;
						collideInto("ladder", x, y + FRAME_HEIGHT * 2, entities);
						for each (ent in entities)
						{
							if (ent.layer == layer + 4)
							{
								mySpritemap.play(myLastDirection + " climb");
								targetY += FRAME_HEIGHT * 2;
								isMoving = true;
								targetLayer = layer + 3;
							}
						}
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
					if (!isJumping && !isClimbing) {
						mySpritemap.play(myLastDirection + " walk", false);
					}
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
						mySpritemap.play(myLastDirection + " idle");
						isClimbing = false;
						layer = targetLayer;
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