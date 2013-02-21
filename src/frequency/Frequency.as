package frequency 
{
    //import com.senocular.display.transform.*;
    
    //import fl.text.TLFTextField;
    import frequency.FrequencyModel;
    import frequency.FrequencyViewModel
    import flash.display.MovieClip;
    import style.FontStyle;
    
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
        private var _FM:FrequencyModel;
        private var _FV:FrequencyView;
        private var _FVM:FrequencyViewModel;
              
        /////////////////////   
        //// MEMBER VARS ////
        /////////////////////

    
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        private static var SPECTRUM_HEIGHT:Number   = 240;
        private static var SPECTRUM_WIDTH:Number    = 1024;
        private static var CONTROLBUTTONS:Array    = [
            { Display:"U->", ID:"LowUp", isButton:true }, 
            { Display:"50", ID:"LowVal", ColdFormat:FontStyle.LOW_TEXT_FORMAT },
            {Display:"<-D", ID:"LowDown", isButton:true }, 
            { Display:" " }, 
            {Display:"U->", ID:"MidUp", isButton:true }, 
            { Display:"50", ID:"MidVal", ColdFormat:FontStyle.MID_TEXT_FORMAT},  
            {Display:"<-D", ID:"MidDown", isButton:true },
            { Display:" " }, 
            {Display:"U->", ID:"HighUp", isButton:true }, 
            { Display:"50", ID:"HighVal", ColdFormat:FontStyle.HIGH_TEXT_FORMAT},  
            {Display:"<-D", ID:"HighDown", isButton:true },
            { Display:" " }, 
            {Display:"U->", ID:"BeatUp", isButton:true }, 
            { Display:"50", ID:"BeatVal", ColdFormat:FontStyle.BEAT_TEXT_FORMAT},  
            {Display:"<-D", ID:"BeatDown", isButton:true }];

        
        public function Frequency() 
        {
            trace("Frequency.Frequency()");
            // create and set mvvm
            _FVM    = new FrequencyViewModel();
            _FV     = new FrequencyView();
            _FM     = new FrequencyModel();
            _FVM.Init(_FM, _FV);
            _FV.Init(_FVM, SPECTRUM_HEIGHT, SPECTRUM_WIDTH, CONTROLBUTTONS);
            _FM.Init(_FVM, SPECTRUM_HEIGHT, SPECTRUM_WIDTH);
            y       = 657;
            addChild(_FV);
            
            //create and set freqBar controls
            
        }
    }    
}