﻿package mochi.as3 {
    import flash.display.MovieClip;

    public class MochiEvents {
        public static const ACHIEVEMENT_RECEIVED:String = "AchievementReceived";

        public static const ALIGN_TOP_LEFT:String = "ALIGN_TL";
        public static const ALIGN_TOP:String = "ALIGN_T";
        public static const ALIGN_TOP_RIGHT:String = "ALIGN_TR";
        public static const ALIGN_LEFT:String = "ALIGN_L";
        public static const ALIGN_CENTER:String = "ALIGN_C";
        public static const ALIGN_RIGHT:String = "ALIGN_R";
        public static const ALIGN_BOTTOM_LEFT:String = "ALIGN_BL";
        public static const ALIGN_BOTTOM:String = "ALIGN_B";
        public static const ALIGN_BOTTOM_RIGHT:String = "ALIGN_BR";

        public static const FORMAT_SHORT:String = "ShortForm";
        public static const FORMAT_LONG:String = "LongForm";

        private static var gameStart:Number;
        private static var levelStart:Number;

        private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();

        public static function getVersion():String {
            return MochiServices.getVersion();
        }

        // --- Basic Event Tracking -----
        public static function startSession( achievementID:String ):void
        {
            // TODO: THIS SHOULD BE CALLED FROM CONNECT!
            MochiServices.send("events_beginSession", { achievementID: achievementID }, null, null );
        }

        // --- UI Notification system ---
        // clip = null to disable automatic notifications (default)
        public static function setNotifications( clip:MovieClip, style:Object ):void
        {
            var args:Object = {}

            for( var s:Object in style )
                args[s] = style[s];
            args.clip = clip;

            MochiServices.send("events_setNotifications", args, null, null );
        }

        // --- Callback system ----------
        public static function addEventListener( eventType:String, delegate:Function ):void
        {
            _dispatcher.addEventListener( eventType, delegate );
        }

        public static function triggerEvent( eventType:String, args:Object ):void
        {
            _dispatcher.triggerEvent( eventType, args );
        }

        public static function removeEventListener( eventType:String, delegate:Function ):void
        {
            _dispatcher.removeEventListener( eventType, delegate );
        }

        // --- Tracking events ----------

        public static function startPlay( tag:String = 'gameplay' ):void {
            MochiServices.send("events_setRoundID", { tag:String(tag) }, null, null );
        }

        public static function endPlay():void {
            MochiServices.send("events_clearRoundID", null, null, null );
        }

        public static function trackEvent( tag:String, value:* = null ):void {
            MochiServices.send("events_trackEvent", { tag: tag, value:value }, null, null );
        }
    }
}
