package hummingbird {
    import org.flixel.*;
    
    public class ExpandedSound extends FlxSound {
        private var fadeOutCallback:Function = null;
        
        public function ExpandedSound():void {
			super();
        }

        public function get length():Number {
            return _sound.length;
        }
    }
}