package hummingbird {
	import org.flixel.FlxPreloader;
    
	public class Preloader extends FlxPreloader {
		public function Preloader():void {
			className = "hummingbird.Main";
			super();
		}
	}
}