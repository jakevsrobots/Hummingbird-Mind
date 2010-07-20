package hummingbird {
    import org.flixel.*;

    public class MuteButton extends FlxSprite {
        public function MuteButton(X:int, Y:int):void {
            super(X, Y, Main.library.getAsset('unmutedIcon'));

            if(FlxG.mute) {
                this.loadGraphic(Main.library.getAsset('mutedIcon'));
            } else {
                this.loadGraphic(Main.library.getAsset('unmutedIcon'));
            }
                
        }

        override public function update():void {
            if(FlxG.mouse.justReleased()) {
                if(overlapsPoint(FlxG.mouse.x, FlxG.mouse.y)) {
                    toggleMute();
                }
            }
            
            super.update();
        }
        
        private function toggleMute():void {
            if(FlxG.mute) {
                FlxG.mute = false;
                this.loadGraphic(Main.library.getAsset('unmutedIcon'));
            } else {
                FlxG.mute = true;
                this.loadGraphic(Main.library.getAsset('mutedIcon'));
            }

        }
    }
}