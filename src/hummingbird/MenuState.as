package hummingbird {
    import org.flixel.*;
    
    public class MenuState extends FlxState {
        private var titleText:FlxText;
        private var subTitleText:FlxText;
        private var helpText:FlxText;        
        private var startButton:FlxButton;
        private var startOverButton:FlxButton;
        private var creditsButton:FlxButton;        
        private var background:FlxSprite;
        private var gameCursor:FlxSprite;

        private var muteButton:MuteButton;
        
        override public function create():void {
            if(Main.musicPlayer == null) {
                Main.musicPlayer = new MusicPlayer('lentEtTriste');
            }
            
            FlxG.flash.start(0xff000000, 0.5, function():void {
                    FlxG.flash.stop();
                });
            
            background = new FlxSprite(0, 0, Main.library.getAsset('menuBackground'));
            gameCursor = new GameCursor(0,0);
            titleText = new FlxText(0, 12, FlxG.width - 12, 'Hummingbird Mind');
            titleText.setFormat(Main.gameFont, 24, 0xff606060, 'right', 0xff303030);
            
            subTitleText = new FlxText(0, 40, FlxG.width - 12, 'by cardboard computer (2010)');
            subTitleText.setFormat(Main.gameFont, 8, 0xff303030, 'right');

            helpText = new FlxText(0, FlxG.height - 10, FlxG.width - 12, '(at any time, press "0" to mute, or "q" to quit)');
            helpText.setFormat(Main.gameFont, 8, 0xff606060, 'right');
            
            startButton = new FlxButton(186, 64, function():void {
                    FlxG.fade.start(0xff000000, 1.25, function():void {
                            FlxG.state = new PlayState();
                            FlxG.fade.stop();
                        })
                });

            startOverButton = new FlxButton(186, 96, function():void {
                    FlxG.fade.start(0xff000000, 1.25, function():void {
                            Main.clearSave();
                            FlxG.state = new PlayState();
                            FlxG.fade.stop();
                        })
                });

            creditsButton = new FlxButton(186, 96, function():void {
                    FlxG.fade.start(0xff000000, 0.5, function():void {
                            FlxG.state = new CreditsState();
                            FlxG.fade.stop();
                        })
                });

            var buttonText:FlxText = new FlxText(0, 0, 96, 'Play');
            buttonText.setFormat(Main.gameFont, 16, 0xffffffff, 'center');
            var buttonHighlightText:FlxText = new FlxText(0, 0, 96, 'Play');
            buttonHighlightText.setFormat(Main.gameFont, 16, 0xff606060, 'center', 0xff303030);

            if(Main.saveGame.data['currentScene'] != null) {
                buttonText.text = buttonHighlightText.text = 'Continue';
            }
            
            startButton.loadText(buttonText, buttonHighlightText);

            var startOverButtonText:FlxText = new FlxText(0, 0, 96, 'Start over');
            startOverButtonText.setFormat(Main.gameFont, 16, 0xffdddddd, 'center');
            var startOverButtonHighlightText:FlxText = new FlxText(0, 0, 96, 'Start over');
            startOverButtonHighlightText.setFormat(Main.gameFont, 16, 0xff606060, 'center', 0xff303030);

            startOverButton.loadText(startOverButtonText, startOverButtonHighlightText);

            var creditsButtonText:FlxText = new FlxText(0, 0, 96, 'Credits');
            creditsButtonText.setFormat(Main.gameFont, 16, 0xffdddddd, 'center');
            var creditsButtonHighlightText:FlxText = new FlxText(0, 0, 96, 'Credits');
            creditsButtonHighlightText.setFormat(Main.gameFont, 16, 0xff606060, 'center', 0xff303030);

            creditsButton.loadText(creditsButtonText, creditsButtonHighlightText);
            //muteButton = new MuteButton(FlxG.width - 16 - 2, 2);
            
            add(background);
            add(startButton);
            if(Main.saveGame.data['currentScene'] != null) {            
                add(startOverButton);
                creditsButton.y = 128;
            }
            add(creditsButton);
            //add(muteButton);
            add(subTitleText);
            add(helpText);            
            add(titleText);
            add(gameCursor);
        }

    }
}