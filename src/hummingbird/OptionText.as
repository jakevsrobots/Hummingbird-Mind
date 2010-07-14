package hummingbird {
    import org.flixel.*;

    public class OptionText extends FlxText {
        public var gotoName:String;
        public var hidden:Boolean = false;
        private var ordinal:uint;
        private var rawText:String;
        
        public function OptionText(X:Number, Y:Number, Width:uint, gotoName:String, Text:String=null, ordinal:uint=0, EmbeddedFont:Boolean=true):void {
            rawText = Text;
			Text = '   ' + ordinal + '. ' + Text;
            
            super(X, Y, Width, Text, EmbeddedFont);

            this.ordinal = ordinal;
            this.gotoName = gotoName;
            
            height = 10;
        }

        override public function set text(Text:String):void {
			var ot:String = _tf.text;
			_tf.text = '   ' + ordinal + '. ' + Text;
			if(_tf.text != ot)
			{
				_regen = true;
				calcFrame();
			}
        }
        
        public function hoverOn():void {
            if(hidden) {
                setFormat(Main.gameFont, 8, 0xff303030, 'left', 0xffa0a0a0);
                _tf.backgroundColor = 0xff606060;
                _tf.background = true;
            } else {
                setFormat(Main.gameFont, 8, 0xff000000, 'left', 0xffa0a0a0);
                _tf.backgroundColor = 0xffffffff;
                _tf.background = true;
            }
        }

        public function hoverOff():void {
            if(hidden) {
                setFormat(Main.gameFont, 8, 0xff303030, 'left');
            } else {
                setFormat(Main.gameFont, 8, 0xffcccccc, 'left');
            }
            
            _tf.background = false;
        }

        public function makeHidden():void {
            var newText:String = '';
            var letters:String = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVW1234567890';

            for(var i:int=0; i < rawText.length; i++) {
                if(letters.indexOf(text.charAt(i)) == -1) {
                    newText += text.charAt(i);
                } else {
                    newText += '-';                    
                }
            }

            text = newText;

            hidden = true;
        }
    }
}