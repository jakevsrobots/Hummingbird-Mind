package hummingbird {
    import org.flixel.*;
    
    public class MusicPlayer {
        private var playerOne:ExpandedSound;
        private var playerTwo:ExpandedSound;

        private var playerTwoDelay:Number;
        private var playerTwoDelayAccum:Number;        

        private var playerTwoDelayActive:Boolean;

        public var currentSongName:String;

        private var volume:Number;

        public var paused:Boolean = false;
        
        public function MusicPlayer(songName:String=null, volume:Number=1.0):void {
            playerOne = new ExpandedSound();
            playerOne.survive = true;
            
            playerTwo = new ExpandedSound();
            playerTwo.survive = true;

            if(songName != null) {
                loadSong(songName, volume);
            }
        }

        public function loadSong(songName:String, volume:Number=1.0):void {
            currentSongName = songName;

            this.volume = volume;

            playerOne.loadEmbedded(Main.library.getAsset(songName), true);
            playerOne.play();
            
            playerTwo.loadEmbedded(Main.library.getAsset(songName), true);

            // wait 50% before starting player 2
            playerTwoDelay = (playerTwo.length / 1000) / 2;
            playerTwoDelayAccum = 0;
            playerTwoDelayActive = true;
        }
        
        public function pause():void {
            paused = true;
            
            if(playerOne.playing) {
                playerOne.pause();
            }
            
            if(!playerTwoDelayActive) {
                if(playerTwo.playing) {
                    playerTwo.pause();
                }
            }
        }

        public function play():void {
            paused = false;
            
            if(!playerOne.playing) {
                playerOne.play();
            }
            
            if(!playerTwoDelayActive) {
                if(!playerTwo.playing) {
                    playerTwo.play();
                }
            }
        }

        public function update():void {
            if(!currentSongName) {
                return;
            }

            playerOne.update();
            playerTwo.update();            
            
            //play();
            
            playerOne.volume = FlxG.volume * this.volume;
            playerTwo.volume = FlxG.volume * this.volume;
            
            if(playerTwoDelayActive) {
                playerTwoDelayAccum += FlxG.elapsed;
                if(playerTwoDelayAccum > playerTwoDelay) {
                    playerTwo.fadeIn(0.5);
                    playerTwo.play();
                    playerTwoDelayActive = false;
                }
            }
        }

        public function fadeIn(duration:Number):void {
            playerOne.fadeIn(duration);
            playerTwo.fadeIn(duration);
        }
        
        public function fadeOut(duration:Number):void {
            playerOne.fadeOut(duration);            
            playerTwo.fadeOut(duration);
        }
    }
}