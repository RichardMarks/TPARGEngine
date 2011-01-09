package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
	/**
	 * simple preloader primitive loading bar
	 * @author Richard Marks
	 */
	public class Preloader extends MovieClip
	{
		// configure preloader
		private const nameOfMainClass:String = "Main";
		private const loadingBarRect:Rectangle = new Rectangle(0, 4, 800, 12);
		private const loadingBarBorderColor:uint = 0xFFFFFF;
		private const loadingBarFillColor:uint = 0xABABAB;
		private const loadingBarBackColor:uint = 0x404040;
		
		///////////////////////////////////////////////////////////////////////
		// don't touch anything below this line
		///////////////////////////////////////////////////////////////////////
		
		private var loadingBarSprite:Sprite;
		
		private function CreateLoadingBarSprite():void
		{
			loadingBarSprite = new Sprite();
			
			loadingBarSprite.graphics.beginFill(loadingBarBorderColor, 1);
			loadingBarSprite.graphics.drawRect(
				loadingBarRect.left, 
				loadingBarRect.top, 
				loadingBarRect.width, 
				loadingBarRect.height); 
			loadingBarSprite.graphics.endFill();
			
			loadingBarSprite.graphics.beginFill(loadingBarBackColor, 1);
			loadingBarSprite.graphics.drawRect(
				loadingBarRect.left + 1, 
				loadingBarRect.top + 1, 
				loadingBarRect.width - 2, 
				loadingBarRect.height - 2); 
			loadingBarSprite.graphics.endFill();
		}
		
		private function DrawLoadingBarProgress(progress:Number):void
		{
			loadingBarSprite.graphics.beginFill(loadingBarBorderColor, 1);
			loadingBarSprite.graphics.drawRect(
				loadingBarRect.left, 
				loadingBarRect.top, 
				loadingBarRect.width, 
				loadingBarRect.height); 
			loadingBarSprite.graphics.endFill();
			
			loadingBarSprite.graphics.beginFill(loadingBarBackColor, 1);
			loadingBarSprite.graphics.drawRect(
				loadingBarRect.left + 1, 
				loadingBarRect.top + 1, 
				loadingBarRect.width - 2, 
				loadingBarRect.height - 2); 
			loadingBarSprite.graphics.endFill();
			
			loadingBarSprite.graphics.beginFill(loadingBarFillColor, 1);
			loadingBarSprite.graphics.drawRect(
				loadingBarRect.left + 1, 
				loadingBarRect.top + 1, 
				(loadingBarRect.width - 2) * progress, 
				loadingBarRect.height - 2); 
			loadingBarSprite.graphics.endFill();
		}
		
		public function Preloader() 
		{
			if (stage) 
			{
				K.Load(this, root.loaderInfo);
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			addEventListener(Event.ENTER_FRAME, OnEnterFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, OnProgress);
			
			CreateLoadingBarSprite();
			addChild(loadingBarSprite);
		}
		
		private function OnEnterFrame(event:Event):void 
		{
			if (currentFrame != totalFrames)
			{
				return;
			}
			
			stop();
			
			
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, OnProgress);
			
			removeChild(loadingBarSprite);
			
			var mainClass:Class = getDefinitionByName(nameOfMainClass) as Class;
			
			if (parent == stage)
			{
				stage.addChildAt(new mainClass() as DisplayObject, 0);
			}
			else
			{
				addChildAt(new mainClass() as DisplayObject, 0);
			}
		}
		
		private function OnProgress(event:ProgressEvent):void 
		{
			DrawLoadingBarProgress((event.bytesLoaded / event.bytesTotal));
		}	
	}
}