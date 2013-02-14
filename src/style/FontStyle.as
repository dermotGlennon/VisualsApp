package style 
{
	/**
     * ...
     * @author Dermot
     */
    import flash.text.Font;
    import flash.text.TextFormat;

    
    [Embed(source = '/fonts/pf_tempesta_five_extended.ttf', fontName = 'TEMPEST_5_EXTENDED', fontWeight = 'regular', unicodeRange = 'U+0020-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E', mimeType = 'application/x-font')]
    public class FontStyle extends Font
    {

        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        public static const BASE_FONT:String             = "TEMPEST_5_EXTENDED";
        public static const BASE_TEXT_COLOUR:int         = 0xFFFFFF;
        public static const BASE_TEXT_HOT_COLOUR:int     = 0xFF0000;
        
        public static const FONT_BOX_COLD_COLOR:Number      = 0X666666;
        public static const FONT_BOX_HOT_COLOR:Number       = 0X000000;
        public static const FONT_BOX_ALPHA:Number           = 1;
        public static const FONT_BOX_HEIGHT_PADDING:Number  = 5;
        public static const FONT_BOX_WIDTH_PADDING:Number   = 10;
        public static const FONT_BASE_SIZE:Number           = 15;

        public static const FONT_UNDERLINE:Boolean          = false
        public static const BASE_FORMAT:TextFormat          = new TextFormat(BASE_FONT, FONT_BASE_SIZE, BASE_TEXT_COLOUR);
        public static const BASE_HOT_FORMAT:TextFormat      = new TextFormat(BASE_FONT, FONT_BASE_SIZE, BASE_TEXT_HOT_COLOUR, null, null, null);
 
    }
}
