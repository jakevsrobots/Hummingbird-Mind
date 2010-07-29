package hummingbird {
    import org.flixel.*;

    public class Soundscape {
        private var playerOne:FlxSound;
        private var playerTwo:FlxSound;

        private var timer:Number;
        
        public function SoundScape():void {
            playerOne = new FlxSound();
            playerTwo = new FlxSound();
        }

        public function play(soundscapeName:String):void {
            playerOne.fadeOut(1.0);
            
        }
        
    }
}