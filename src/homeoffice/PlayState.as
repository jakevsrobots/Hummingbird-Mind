package homeoffice {
    import org.flixel.*;

    public class PlayState extends FlxState {
        private var background:FlxSprite;
        private var gameData:Object;
        private var currentRoomName:String;
        private var gameCursor:FlxSprite;

        [Embed(source="/../data/game.xml",
                mimeType="application/octet-stream")]
        private var GameXMLFile:Class;
        
        private var titleText:FlxText;
        private var controls:FlxGroup;
        
        private var hotspots:FlxGroup;

        private var roomWidth:uint = 800;
        private var roomHeight:uint = 600;
        
        override public function create():void {
            var gameDataXML:XML = new XML(new GameXMLFile());

            gameData = {
                'rooms': {},
                'startingRoom': gameDataXML.@startingRoom
            };
            
            for each(var roomNode:XML in gameDataXML.room) {
                gameData['rooms'][roomNode.@name] = {
                    'title': roomNode.@title,
                    'name': roomNode.@name,
                    'background': roomNode.@background,
                    'hotspots': []};
                    
                for each(var hotspotNode:XML in roomNode.hotspot) {
                    var hotspotRect:HotSpot = new HotSpot(
                        uint(hotspotNode.@x) - (roomWidth / 2),
                        uint(hotspotNode.@y) - (roomHeight / 2),
                        hotspotNode.@width, hotspotNode.@height
                    );
                    
                    gameData['rooms'][roomNode.@name]['hotspots'].push(hotspotRect);
                }
                
            }

            hotspots = new FlxGroup();
            background = new FlxSprite(0,0);
            gameCursor = new GameCursor(0,0);

            var controlGutterHeight:uint = 20;
            var controlPadding:uint = 2;
            
            controls = new FlxGroup();
            controls.scrollFactor = new FlxPoint(0,0);
            
            var controlsBackground:FlxSprite = new FlxSprite(0, FlxG.height - controlGutterHeight);
            controlsBackground.createGraphic(FlxG.width, controlGutterHeight, 0xff000000);
            controls.add(controlsBackground, true);
            titleText = new FlxText(controlPadding, (FlxG.height - controlGutterHeight) + controlPadding, FlxG.width, 'test me');
            //titleText.setFormat();
            controls.add(titleText, true);
            
            loadRoom(gameData['startingRoom']);

            add(background);
            add(hotspots);
            add(controls);
            add(gameCursor);

            FlxG.follow(gameCursor);
        }

        override public function update():void {
            for each(var hotspot:HotSpot in hotspots.members) {
                if(gameCursor.overlaps(hotspot)) {
                    hotspot.fadeIn();
                } else {
                    hotspot.fadeOut();
                }
            }
            super.update();
        }

        private function loadRoom(roomName:String):void {
            currentRoomName = roomName;
            var roomData:Object = gameData['rooms'][roomName];
            
            background.loadGraphic(Main.library.getAsset(roomData['background']));
            background.x = 0 - (roomWidth / 2);
            background.y = 0 - (roomHeight / 2);
            titleText.text = roomData['title'];

            hotspots = new FlxGroup;
            for each(var hotspot:HotSpot in gameData['rooms'][roomName].hotspots) {
                hotspots.add(hotspot);
            }

            FlxG.followBounds(background.x, background.y,
                background.width / 2, background.height / 2, true);
        }
    }
}