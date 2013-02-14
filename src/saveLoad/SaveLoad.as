package saveLoad
{
    import org.casalib.display.CasaSprite
    import saveLoad.SaveLoadModel;
    import saveLoad.SaveLoadView;
    import saveLoad.SaveLoadViewModel;
    
    public class SaveLoad extends CasaSprite
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////
        private var saveLoadViewModel:SaveLoadViewModel;
        private var saveLoadView:SaveLoadView;
        private var saveLoadModel:SaveLoadModel;
        
        /////////////////////   
        //// MEMBER VARS ////
        /////////////////////
        
        
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        
        
        public function SaveLoad()
        {
            saveLoadViewModel   = new SaveLoadViewModel(saveLoadView, saveLoadModel);
            saveLoadView        = new SaveLoadView(saveLoadViewModel);
            saveLoadModel       = new SaveLoadModel(saveLoadViewModel);
            Layout();
        }
        private function Layout():void
        {
            addChild(saveLoadView);
        }
    }
}