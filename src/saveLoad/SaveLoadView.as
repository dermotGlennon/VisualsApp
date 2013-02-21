package saveLoad
{
    import components.HorizTextButtons;
    import flash.events.Event;
    import org.casalib.display.CasaSprite;
    import saveLoad.SaveLoadViewModel;
    


    
    public class SaveLoadView extends CasaSprite
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////
        private var htb_freq:HorizTextButtons;
        
        /////////////////////   
        //// MEMBER VARS ////
        /////////////////////
        private var m_vm:SaveLoadViewModel;
        
        
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        public function SaveLoadView(ViewModel:SaveLoadViewModel)
        {
            m_vm = ViewModel;

            htb_freq = new HorizTextButtons( 
            { ButtonArr:[ 
            { Display:"RESET", ID:"reset", isButton:true }, 
            { Display:"/" },
            {Display:"new", ID:"new", isButton:true }, 
            { Display:"/" }, 
            {Display:"open", ID:"open", isButton:true }, 
            { Display:"/" },  
            {Display:"save", ID:"save", isButton:true } ] } );
            htb_freq.addEventListener(HorizTextButtons.BUTTON_HIT, _BtnHit);
            _LayOut();
        }
        private function _LayOut():void
        {
            htb_freq.y = 634;
            htb_freq.x = 2;
            addChild(htb_freq);
        }
        private function _BtnHit(e:Event):void
        {
            trace("saveLoadButtonHit:"+e.currentTarget.bttnHit);
        }
    }
}