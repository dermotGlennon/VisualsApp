package components 
{
    import components.parts.TextBase;
    import components.TextButton;
    import org.casalib.display.CasaSprite;
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
        private var mButtonCount:Number;
        private var mButtonPadding:Number = 5;
        private var mButtonDivider:String = " / ";

        /////////////////////
        //// STATIC VARS ////
        /////////////////////
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
                var item:TextButton = new TextButton(ButtonArr[i]);
                item.x = X
                addChild(item);
                X += item.GetWidth();
                if(i != ButtonArr.length -1) 
                {
                    var divider:TextBase = new TextBase( { Display:"/" } );
                    divider.x = X;
                    X += divider.GetWidth();
                    addChild(divider);
                }
                
                
            }
        }
    }

}