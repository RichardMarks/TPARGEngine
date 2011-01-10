package 
{
	import flash.events.*;
	import flash.geom.*;
	import game.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	/**
	 * TPARGE version 1.0
	 * started January 04, 2011
	 * 
	 * The Top-down Platformer Action-RPG Game Engine Project
	 * © Copyright 2011, Bang Bang Attack Studios
	 * http://bbastudios.blogspot.com
	 * 
	 * @author Richard Marks
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Engine
	{
		private var noFocusBg:Image;
		private var noFocusText:Text;
		
		static public var hasFocus:Boolean = true;
		public function Main() { super(800, 600); }
		override public function init():void 
		{
			stage.addEventListener(Event.DEACTIVATE, OnLostFocus);
			stage.addEventListener(Event.ACTIVATE, OnGainedFocus);
			FP.world = new GameWorld;
			
			Text.size = 32;
			
			noFocusBg = Image.createRect(FP.width, FP.height, 0x000000);
			noFocusText = new Text("Click to Play");
			noFocusText.x = int((noFocusBg.width - noFocusText.width) * 0.5);
			noFocusText.y = int((noFocusBg.height - noFocusText.height) * 0.5);
			
			FP.screen.scale = 1;
			
			FP.console.enable();
			
			super.init();
		}
		
		private function OnGainedFocus(event:Event):void { hasFocus = true; }
		private function OnLostFocus(event:Event):void { hasFocus = false; }
		override public function update():void { if (!hasFocus) { return; } super.update(); }
		
		override public function render():void 
		{
			if (!hasFocus) 
			{
				noFocusBg.render(new Point, new Point);
				noFocusText.render(new Point, new Point);
				return; 
			}
			
			super.render();
		}
	}
}