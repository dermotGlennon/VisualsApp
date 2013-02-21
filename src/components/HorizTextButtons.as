package components 
{
    import components.parts.TextBase;
    import components.TextButton;
    import org.casalib.display.CasaSprite;
    import flash.events.Event;
    /**
     * ...
     * @author Dermot
     */
    public class HorizTextButtons extends CasaSprite 
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////
        
        /////////////////////
        //// MEMBER VARS ////
        /////////////////////
        // private var mButtonCount:Number;
        //private var mButtonPadding:Number = 5;
        //public static var UPDATE_SPECTRUM:String = 'spectrumUpdate';
        public var m_buttonHit:String;
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        public static var BUTTON_HIT:String = "horizontal button hit";
        private static var DEFAULT_BUTTON_NAME:String = "btn_";
        private static var DEFAULT_TEXT_NAME:String = "txt_";
  
        public function HorizTextButtons(Params:Object) 
        {
           _CreateButtons(Params.ButtonArr);
           super();
        }
        
        private function _CreateButtons(ButtonArr:Array):void
        {
            var X:Number = 0;
            for (var i:int = 0; i < ButtonArr.length; i++) 
            {
                //ButtonArr[i].Size = mTextSize;
         
                if (ButtonArr[i].isButton) 
                {
                    var buttonItem:TextButton = new TextButton(ButtonArr[i]);
                    buttonItem.name = (ButtonArr[i].ID == undefined) ? DEFAULT_BUTTON_NAME + i:ButtonArr[i].ID;
                    buttonItem.x = X
                    buttonItem.addEventListener(TextButton.BUTTON_EVENT, BtnHit);
                    addChild(buttonItem);
                    X += buttonItem.GetWidth();
                }
                else 
                {
                    var textItem:TextBase = new TextBase( { Display:ButtonArr[i].Display, ColdFormat:ButtonArr[i].ColdFormat } );
                    textItem.name = (ButtonArr[i].ID == undefined) ? DEFAULT_TEXT_NAME + i:ButtonArr[i].ID;
                    textItem.x = X
                    addChild(textItem);
                    X += textItem.GetWidth();
                }
            }
        }
        public function BtnHit(e:Event):void
        {
           bttnHit = e.currentTarget.name;
           dispatchEvent(new Event(HorizTextButtons.BUTTON_HIT));
        }
        
        // getter and setter
        public function get bttnHit ():String
        {
            return m_buttonHit;
        } 
        public function set bttnHit(s:String):void
        {
            m_buttonHit = s;
        }
        
    }

}