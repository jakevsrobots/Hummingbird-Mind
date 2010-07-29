package hummingbird {
    import org.flixel.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;    
	import flash.text.TextFormat;
    
    public class RollingText extends FlxText {
        private var targetText:String;
        public var rolling:Boolean = false;
        private var characterIndex:uint = 0;
        private var charactersPerSecond:Number;
        private var secondsPerCharacter:Number;
        private var rollingTimer:Number;
        private var callback:Function;
        private var currentLine:String;
        private var wordSeparatingChars:Array;
        
        // A dummy text object for getting line lengths
        private var dummyText:TextField;
        
        public function RollingText(X:Number, Y:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=true):void {
            super(X, Y, Width, Text, EmbeddedFont);

            wordSeparatingChars = [" ", "\n"];
            
            currentLine = '';
            
            rollingTimer = 0;
            charactersPerSecond = 24;

            secondsPerCharacter = 1 / charactersPerSecond; // Just for convenience
        }

        override public function update():void {
            if(rolling) {
                rollingTimer += FlxG.elapsed;

                if(rollingTimer >= secondsPerCharacter) {
                    rollingTimer = 0;

                    if(characterIndex < targetText.length) {
                        var nextChar:String = targetText.charAt(characterIndex);
                        var sep:String;

                        // Check if this word will wrap.
                        if(wordSeparatingChars.indexOf(nextChar) != -1) {
                            var nextWordEnd:uint = targetText.length;

                            for each(var separator:String in wordSeparatingChars) {
                                var nextIndex:uint = targetText.indexOf(separator, characterIndex+1);

                                if(nextIndex < nextWordEnd) {
                                    nextWordEnd = nextIndex;
                                }
                            }
                            
                            var nextWord:String = targetText.substring(characterIndex+1, nextWordEnd);
                            var lineWidth:uint = getLineWidth(currentLine + ' ' + nextWord);

                            // Force the line to wrap now instead of partially writing the
                            // word on the above line.
                            if(lineWidth >= this.width) {
                                nextChar = "\n";
                            }
                        }
                        
                        currentLine += nextChar;
                        text += nextChar;
                        characterIndex += 1;
                    } else {
                        resetRoll();
                        runCallback();
                    }
                }
            }
            
            super.update();
        }

        private function runCallback():void {
            if(callback != null) {
                callback();
            }
        }
        
        private function resetRoll():void {
            targetText = '';
            currentLine = ''
            rolling = false;
            characterIndex = 0;
            rollingTimer = 0;
        }

        private function getLineWidth(line:String):uint {
            dummyText = new TextField();
            dummyText.autoSize = TextFieldAutoSize.LEFT;
            dummyText.embedFonts = _tf.embedFonts;
            dummyText.sharpness = _tf.sharpness;
            dummyText.defaultTextFormat = _tf.defaultTextFormat;
            dummyText.setTextFormat(_tf.defaultTextFormat);
            
            dummyText.text = line;
            
            return dummyText.width;
        }
        
        public function displayText(text:String, callback:Function=null):void {
            this.text = '';
            resetRoll();
            targetText = text;
            rolling = true;
            this.callback = callback;
        }

        public function forceComplete():void {
            text = targetText;
            resetRoll();
            runCallback();
        }
    }
}