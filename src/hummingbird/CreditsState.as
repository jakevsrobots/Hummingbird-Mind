package hummingbird {
    import org.flixel.*;
    
    public class CreditsState extends FlxState {
        private var titleText:FlxText;
        private var subTitleText:FlxText;
        private var creditsText:FlxText;        
        private var startButton:FlxButton;
        private var creditsButton:FlxButton;        
        private var background:FlxSprite;
        private var gameCursor:FlxSprite;
        
        override public function create():void {
            if(Main.musicPlayer == null) {
                Main.musicPlayer = new MusicPlayer('lentEtTriste');
            }
            
            FlxG.flash.start(0xff000000, 1.5, function():void {
                    FlxG.flash.stop();
                });
            
            background = new FlxSprite(0, 0, Main.library.getAsset('creditsBackground'));
            background.alpha = 0.3;
            gameCursor = new GameCursor(0,0);
            titleText = new FlxText(0, 12, FlxG.width - 12, 'Hummingbird Mind');
            titleText.setFormat(Main.gameFont, 24, 0xffa0a0a0, 'right', 0xff303030);
            
            subTitleText = new FlxText(0, 40, FlxG.width - 12, 'by cardboard computer (2010)');
            subTitleText.setFormat(Main.gameFont, 8, 0xff808080, 'right');

            creditsText = new FlxText(10, 60, 272, "");
            creditsText.setFormat(Main.gameFont, 8, 0xff808080, 'left');

            creditsText.text = "Code, design, writing+music by Jake Elliott.\n\n";
            creditsText.text += "Features artwork derived or inspired by photographs licensed CC-BY, by the following Flickr users: ";
            creditsText.text += "airbeagle, rubbermaid, laurenprofeta, daveynin, wonderlane, carbonnyc, dave_mcmt, gypsygirl09, karpov85, a_mason, michael freudigmann, maxwellgs, sylvar, spablab, chefranden, kretyen, jdickert, peasap and jafergas.\n\n";
            
            creditsText.text += "Features sound effects derived from recordings licensed CC Sampling Plus 1.0 by the following Freesound users: "
            creditsText.text += "RCA, RHUmphries, sagetyrtle, Corsica_S and JasonElrod.";
            
            startButton = new FlxButton(186, 170, function():void {
                    FlxG.fade.start(0xff000000, 1.25, function():void {
                            FlxG.state = new MenuState();
                            FlxG.fade.stop();
                        })
                });

            var buttonText:FlxText = new FlxText(0, 0, 96, 'Back');
            buttonText.setFormat(Main.gameFont, 16,  0xffffffff, 'center');
            var buttonHighlightText:FlxText = new FlxText(0, 0, 96, 'Back');
            buttonHighlightText.setFormat(Main.gameFont, 16, 0xff606060, 'center', 0xff303030);
            
            startButton.loadText(buttonText, buttonHighlightText);
            
            add(background)
            add(startButton)
            add(subTitleText);
            add(titleText);
            add(creditsText);
            add(gameCursor);
        }

    }
}