package frequency 
{
    //import com.senocular.display.transform.*;
    
    //import fl.text.TLFTextField;
    import frequency.FrequencyModel;
    import frequency.FrequencyViewModel
    import flash.display.MovieClip;
    
   // import frequency.freqBar.FreqBar;

    /**
     * ...
     * @author Dermot
     */
    public class Frequency extends MovieClip 
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////

        private var freqModel:FrequencyModel;
        private var freqView:FrequencyView;
        private var freqViewModel:FrequencyViewModel;
              
        /////////////////////   
        //// MEMBER VARS ////
        /////////////////////

    
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        private static var SPECTRUM_HEIGHT:Number   = 240;
        private static var SPECTRUM_WIDTH:Number    = 800;
        /*private static var SPECTRUM_TOP:Number      = 0;
        private static var SPECTRUM_LEFT:Number     = 111;*/
        
        public function Frequency() 
        {
            trace("Frequency.Frequency()");
            freqViewModel   = new FrequencyViewModel();
            freqView        = new FrequencyView();
            freqModel       = new FrequencyModel();
            freqViewModel.Init(freqModel, freqView);
            freqView.Init(freqViewModel, SPECTRUM_HEIGHT, SPECTRUM_WIDTH);
            freqModel.Init(freqViewModel, SPECTRUM_HEIGHT, SPECTRUM_WIDTH);
            y               = 657;
            freqView.y      = 0;
            addChild(freqView);
        }
        
        /*private function onAddedToStage(e:Event):void 
        {
            
           
         }*/

    }    
}