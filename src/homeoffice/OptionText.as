package homeoffice {
    import org.flixel.*;

    public class OptionText extends FlxText {
        public var gotoName:String;
        
        public function OptionText(X:Number, Y:Number, Width:uint, gotoName:String, Text:String=null, EmbeddedFont:Boolean=true):void {
            super(X, Y, Width, Text, EmbeddedFont);

            this.gotoName = gotoName;
            
            _tf.backgroundColor = 0xffffffff;
            
            height = 10;
        }

        public function hoverOn():void {
            setFormat(Main.gameFont, 8, 0xff000000, 'left', 0xffa0a0a0);
           _tf.background = true;
        }

        public function hoverOff():void {
           setFormat(Main.gameFont, 8, 0xffcccccc, 'left');
            _tf.background = false;
        }
    }
}