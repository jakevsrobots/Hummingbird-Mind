package hummingbird {
    import org.flixel.*;
    
    public class HotSpot extends FlxSprite {
        private var fadeInSpeed:Number = 1;
        private var fadeOutSpeed:Number = 3;        
        private var fadeState:uint;

        public static var INVISIBLE:uint = 0;
        public static var FADING_IN:uint = 1;
        public static var FADING_OUT:uint = 2;
        public static var VISIBLE:uint = 3;        

        private var maxAlpha:Number = 0.2;
        
        public function HotSpot(X:Number, Y:Number, width:Number, height:Number):void {
            super(X, Y);

            this.createGraphic(width, height, 0xff000000);
            this.alpha = 0.0;
            this.blend = "invert";

            fadeState = INVISIBLE;
        }

        override public function update():void {
            if(fadeState == FADING_IN) {
                this.alpha += fadeInSpeed * FlxG.elapsed;
                
                if(this.alpha >= maxAlpha) {
                    this.alpha = maxAlpha;
                    fadeState = VISIBLE;
                }
            } else if(fadeState == FADING_OUT) {
                this.alpha -= fadeOutSpeed * FlxG.elapsed;
                
                if(this.alpha <= 0.0) {
                    this.alpha = 0.0;
                    fadeState = INVISIBLE;
                }
            }
            
            super.update();
        }
        
        public function fadeIn():void {
            fadeState = FADING_IN;
        }
        public function fadeOut():void {
            fadeState = FADING_OUT;
        }
    }
}