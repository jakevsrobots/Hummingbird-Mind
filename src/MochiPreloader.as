package {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.IOErrorEvent;
    import flash.utils.getDefinitionByName;

    import mochi.as3.*;

    // Must be dynamic!
    public dynamic class MochiPreloader extends MovieClip {
        // Keep track to see if an ad loaded or not
        private var did_load:Boolean;

        // Change this class name to your main class
        public static var MAIN_CLASS:String = "hummingbird.Main";

        // Substitute these for what's in the MochiAd code
        public static var GAME_OPTIONS:Object = {id: "619719942d9070da", res:"600x400"};

        public function MochiPreloader() {
            super();

            var f:Function = function(ev:IOErrorEvent):void {
                // Ignore event to prevent unhandled error exception
            }
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);

            var opts:Object = {};
            for (var k:String in GAME_OPTIONS) {
                opts[k] = GAME_OPTIONS[k];
            }

            opts.ad_started = function ():void {
                did_load = true;
            }

            opts.ad_finished = function ():void {
                // don't directly reference the class, otherwise it will be
                // loaded before the preloader can begin
                var mainClass:Class = Class(getDefinitionByName(MAIN_CLASS));
                var app:Object = new mainClass();
                addChild(app as DisplayObject);
            }

            opts.clip = this;
            //opts.skip = true;

            MochiAd.showPreGameAd(opts);
        }


    }

}
