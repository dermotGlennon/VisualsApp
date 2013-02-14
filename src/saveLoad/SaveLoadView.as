package saveLoad
{
    import components.HorizTextButtons;
    import org.casalib.display.CasaSprite;
    import saveLoad.SaveLoadViewModel;
    


    
    public class SaveLoadView extends CasaSprite
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////
        private var _saveLoad_freq:HorizTextButtons;
        
        /////////////////////   
        //// MEMBER VARS ////
        /////////////////////
        private var mViewModel:SaveLoadViewModel;
        
        
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        public function SaveLoadView(ViewModel:SaveLoadViewModel)
        {
            mViewModel = ViewModel;

            _saveLoad_freq = new HorizTextButtons( {ButtonArr:[ {Display:"RESET", ID:"reset"},{Display:"new", ID:"new"}, {Display:"open", ID:"open"}, {Display:"save", ID:"save"}]});
            _LayOut();
        }
        private function _LayOut():void
        {
            _saveLoad_freq.y = 634;
            _saveLoad_freq.x = 2;
            addChild(_saveLoad_freq);
        }
    }
}