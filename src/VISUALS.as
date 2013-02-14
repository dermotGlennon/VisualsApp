package
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.greensock.loading.ImageLoader;
	import flash.display.MovieClip;
	import frequency.Frequency;
	import net.hires.debug.Stats;
	import saveLoad.SaveLoad;
	
	[SWF(backgroundColor="#000000", width="1600", height="900", frameRate="60")]
	public class VISUALS extends MovieClip
	{
		/////////////////////
		//// INSTANCES //////
		/////////////////////
		public var frequency:Frequency;
		public var saveLoad:SaveLoad;
		private var queue:LoaderMax;
		
		/////////////////////
		//// MEMBER VARS ////
		/////////////////////
		
		/////////////////////
		//// STATIC VARS ////
		/////////////////////
		
		public function VISUALS():void
		{
			DevStuff();
			Init();
			Layout();
		}
		
		private function Init():void
		{
			// sound analysis
			/*
			mcSpectrum = new SpectrumAnalyzer();sss
			mcSpectrum = new SpectrumAnalyzer();
			mcSpectrum.x = 3;
			mcSpectrum.y = 663;
			addChild(mcSpectrum);*/
			
			frequency = new Frequency();
			saveLoad = new SaveLoad();
			
		}
		
		private function Layout():void
		{
			
			addChild(frequency);
			addChild(saveLoad)
		}
		
		private function DevStuff():void
		{
			MonsterDebugger.initialize(this);
			var loader:ImageLoader = new ImageLoader("../_assets/master.png", {name: "photo1", container: this, x: 0, y: 0, width: 1600, height: 900, alpha:0, scaleMode: "proportionalInside", centerRegistration: false, onComplete: onImageLoad});
			
			//begin loading
			loader.load();
			var mcStats:Stats = new Stats();
			addChild(mcStats);
			mcStats.y = 0;
			mcStats.x = 1530;
		}
		
		public function onImageLoad(event:LoaderEvent):void
		{
			var image:ContentDisplay = LoaderMax.getContent("photo1");
			TweenLite.to(image, 1, {alpha: 1});
			trace(event.target + " is complete!");
		}
		
	}
}
