package homeoffice {
    import org.flixel.*;

    public class GameCursor extends FlxSprite {
        private var alphaDir:int = -1;
        private var fadeSpeed:Number = 5;
        private var minAlpha:Number = 0.5;
        private var maxAlpha:Number = 0.9;
        
        public function GameCursor(X:Number, Y:Number):void {
            super(X, Y, Main.library.getAsset('cursor'));

            alpha = maxAlpha;

            this.blend = "invert";
        }

        override public function update():void {
            this.x = FlxG.mouse.x - (this.width / 2);
            this.y = FlxG.mouse.y - (this.height / 2);

            alpha += alphaDir * fadeSpeed * FlxG.elapsed;

            if(alphaDir == -1 && alpha <= minAlpha) {
                alpha = minAlpha;
                alphaDir = 1;
            } else if(alphaDir == 1 && alpha >= maxAlpha) {
                alpha = maxAlpha;
                alphaDir = -1;
            }
            
            super.update();
        }
    }
}