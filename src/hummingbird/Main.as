package hummingbird {
    import org.flixel.*;
    import AssetLibrary;
    
	import flash.events.*;
    import flash.net.SharedObject;
    
    [SWF(width="600", height="400", backgroundColor="#000000")];

    [Frame(factoryClass="hummingbird.Preloader")]
    
    public class Main extends FlxGame {
        public static var bgcolor:uint = 0xff000000;
        public static var library:AssetLibrary;        
        public static var instance:Main;

        [Embed(source='/../data/Antenna8.ttf', fontFamily='antenna8', embedAsCFF="false")]
        public static var Antenna8FontClass:String;
        [Embed(source='/../data/04B_03__.TTF', fontFamily='zerofourbee', embedAsCFF="false")]
        public static var ZeroFourFontClass:String;

        public static var gameFont:String;

        public static var saveGame:SharedObject;
        public static var musicPlayer:MusicPlayer;
        
        public function Main():void {
            gameFont = 'zerofourbee';
            
            Main.library = new AssetLibrary();
            Main.instance = this;

            saveGame = SharedObject.getLocal('hummingbirdMind_savedata');
            if(saveGame.data['flags'] == null || saveGame.data['currentScene'] == null) {
                Main.clearSave();
            }
            
            super(300, 200, MenuState, 2);
            FlxState.bgColor = Main.bgcolor;

            pause = new GamePause();
        }

        override protected function update(event:Event):void {
            super.update(event);
            
            if(Main.musicPlayer != null) {
                Main.musicPlayer.update();

                /*
                if(FlxG.pause) {
                    Main.musicPlayer.pause();
                } else {
                    Main.musicPlayer.play();
                }*/
            }

        }
        
        public static function save(flags:Object, currentScene:String):void {
            saveGame.data['flags'] = flags;
            saveGame.data['currentScene'] = currentScene;
            
            saveGame.flush();
        }

        public static function clearSave():void {
            saveGame.data['flags'] = {};
            saveGame.data['currentScene'] = null;

            saveGame.flush();
        }
    }
}