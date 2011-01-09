package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	/**
	 * kongregate API
	 * @author Richard Marks
	 */
	public class K 
	{
		static private var kongregate:* = null;
		static public var loaded:Boolean = false;
		static public var messages:Vector.<String> = new Vector.<String>();
		
		static public function SubmitStat(statName:String, statValue:Number):void
		{
			if (!loaded)
			{
				messages.push("SubmitStat() Kong API not loaded!");
				return;
			}
			
			kongregate.stats.submit(statName, statValue);
		}
		
		static public function IsGuest():Boolean
		{
			if (!loaded)
			{
				messages.push("IsGuest() Kong API not loaded!");
				return false;
			}
			
			return kongregate.services.isGuest();
		}
		
		static public function GetUserName():String
		{
			if (!loaded)
			{
				messages.push("GetUserName() Kong API not loaded!");
				return "";
			}
			
			return kongregate.services.getUsername();
		}
		
		static public const INVALID_USER_ID:Number = -9999;
		
		static public function GetUserID():Number
		{
			if (!loaded)
			{
				messages.push("GetUserName() Kong API not loaded!");
				return INVALID_USER_ID;
			}
			
			return kongregate.services.getUserId();
		}
		
		static public function GetGameAuthenticationToken():String
		{
			if (!loaded)
			{
				messages.push("GetGameAuthenticationToken() Kong API not loaded!");
				return "";
			}
			
			return kongregate.services.getGameAuthToken();
		}
		
		static public function Load(parent:MovieClip, loaderInfo:LoaderInfo):void
		{
			messages.push("Loading Kong API");
			var paramsObj:Object = LoaderInfo(loaderInfo).parameters;
			var apiPath:String = paramsObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			messages.push("API Path:", apiPath);
			Security.allowDomain(apiPath);
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnKongLoadComplete);
			loader.load(request);
			parent.addChild(loader);
			trace(messages);
		}
		
		static private function OnKongLoadComplete(e:Event):void
		{
			messages.push("Kong API Loaded");
			loaded = true;
			kongregate = e.target.content;
			kongregate.services.connect();
			messages.push("kongregate object:", kongregate);
			messages.push("connected: ", kongregate.connected);
			messages.push("services: ", kongregate.services);
			trace(messages);
		}	
	}
}