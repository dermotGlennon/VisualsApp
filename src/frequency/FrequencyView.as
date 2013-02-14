package frequency
{
    import flash.display.MovieClip;
    import com.senocular.display.transform.*;
    import flash.events.Event;
    import __AS3__.vec.Vector;
    import frequency.FrequencyViewModel;
    //import fl.text.TLFTextField;
    import flash.display.MovieClip;
    import frequency.freqBar.FreqBar;
    import flash.events.MouseEvent;
    import flashx.textLayout.container.TextContainerManager;


    public class FrequencyView extends MovieClip
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////
        //public var txtLabel:TLFTextField;
        public var transformTool:TransformTool;
 
        
        public var mcMidFreq:FreqBar;
        public var mcLowFreq:FreqBar;
        public var mcHighFreq:FreqBar;
        public var mcBeatBar:FreqBar;
        
        
        /////////////////////   
        //// MEMBER VARS ////
        /////////////////////
        private var mViewModel:FrequencyViewModel;
        private var mMag:Vector.<Number>;
        private var mFreq:Vector.<Number>;
        private var barArr:Array;
        private var mSpectrumH:Number;
        private var mSpectrumW:Number;

        /*private var mSpectrumTop:Number;
        private var mSpectrumLeft:Number;*/
        
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        private static var FREQ_MIN_H_W:Number = 50;
        
        public function FrequencyView()
        {
            trace("FrequencyView.FrequencyView()");
           
            super();
        }
        public function Init(FreqViewModel:FrequencyViewModel, SpectrumHeight:Number, SpectrumWidth:Number):void
        {
             mViewModel      = FreqViewModel;
            mSpectrumH      = SpectrumHeight;
            mSpectrumW      = SpectrumWidth;
  
            
            transformTool   = new TransformTool(new ControlSetScaleCorners());
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        private function onAddedToStage(e:Event):void
        {
            trace("FrequencyView.onAddedToStage()");
            //txtLabel.text = "";
            mcLowFreq   = new FreqBar( { Id:"Low", Height:160, Width:276,  X:10, Y:78, Alpha:.2, childUseMouse:false,  Color:0xff0000 } ); 
            mcMidFreq   = new FreqBar( { Id:"Mid", Height:146, Width:325, X:248, Y:92, Alpha:.2,childUseMouse:false,  Color:0x00ff00 } ); 
            mcHighFreq  = new FreqBar( { Id:"High", Height:97, Width:256, X:535, Y:137, Alpha:.2, childUseMouse:false, Color:0x0000ff } );
            mcBeatBar   = new FreqBar( { Id:"Beat", Height:100, Width:793,  X:5, Y:20, Alpha:.2, childUseMouse:false, Color:0xffffff } );
            barArr      = [mcLowFreq, mcMidFreq, mcHighFreq, mcBeatBar];
            
            //set up the transform tool
            transformTool.addChild(new ControlReset());
            var removeReg:ControlRegistration = new ControlRegistration();
            removeReg.editable = false;
    
            //transformTool.addChild(new ControlRegistration());
            transformTool.addChild(removeReg);
            transformTool.autoRaise         = true;
            transformTool.maxHeight         = mSpectrumH;
            transformTool.maxWidth          = mSpectrumW;
            transformTool.negativeScaling   = false;
            transformTool.minHeight         = FREQ_MIN_H_W;
            transformTool.minWidth          = FREQ_MIN_H_W;
            
            addChild(transformTool);
            
            // add/remove listeners
            mViewModel.addEventListener(FrequencyViewModel.UPDATE_SPECTRUM, _DrawSpectrum);
            transformTool.addEventListener(TransformTool.TRANSFORM_CHANGED,_BarTransforming);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, transformTool.deselect);
            addEventListener(MouseEvent.MOUSE_DOWN, transformTool.select);
            
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            
            _SetInitialBarVals();//TODO get from xml 
        }
        
        private function _BarTransforming(e:Event):void
        {
            var mc:MovieClip = e.target.target;
            //limitStageBorder(mc, e);
            //trace(mc.id + " :" + mc.width);
            mViewModel.setRangeValue(  mc.id, mc.x, mc.y, mc.height, mc.width   );
            
        }
     
        private function _SetInitialBarVals():void
        {
            for (var i:int = 0; i < barArr.length; i++) 
            {
               mViewModel.setRangeValue( barArr[i].id, barArr[i].x, barArr[i].y, barArr[i].height, barArr[i].width );
               addChild(barArr[i]);
            }
        }
        
        private function limitStageBorder(mc:MovieClip, e:Event):void
        {

            /*var mcWidth:uint = mc.width;
            var mcHeight:uint = mc.height;
            
            if (mc.x + mc.width > mSpectrumW) 
            {
                trace("out Right");
                transformTool.deselect(e);
                mc.x = mSpectrumW - (mcWidth + 2);
            }
            else if (mc.x  < 0) 
            {
                trace("out Left");
                mc.x = 2;
                transformTool.deselect(e);
            }
            
            if (mc.y < 0) 
            {
                trace("out Top");
                mc.y = 2;
                transformTool.deselect(e);
            }
            else if (mc.y + mcHeight > mSpectrumH) 
            {
                trace("out Bottom");
                mc.y = mSpectrumH - (mcHeight + 2);
                transformTool.deselect(e);
            }*/
        }
        
        private function _DrawSpectrum(e:Event):void
        {
            if (mViewModel.mag && mViewModel.freq == null) 
            {
                return;
            }
            mMag     = mViewModel.mag;
            mFreq    = mViewModel.freq;
            // Basic constants
            const MIN_FREQ:Number   = 10;// Minimum frequency (Hz) on horizontal axis.
            const MAX_FREQ:Number   = 4000;// Maximum frequency (Hz) on horizontal axis.
            const FREQ_STEP:Number  = 500;// Interval between ticks (Hz) on horizontal axis.
            const MAX_DB:Number     = -0.0;// Maximum dB magnitude on vertical axis.
            const MIN_DB:Number     = -60.0;// Minimum dB magnitude on vertical axis.
            const DB_STEP:Number    = 10;// Interval between ticks (dB) on vertical axis.
            const TOP:Number        = 0;// Top of graph
            const LEFT:Number       = 0;// Left edge of graph
            var HEIGHT:Number       = mSpectrumH;// Height of graph
            var WIDTH:Number        = mSpectrumW;// Width of graph
            const TICK_LEN:Number   = 10;// Length of tick in pixels
            
            // Derived constants
            const BOTTOM:Number = TOP+HEIGHT;                    // Bottom of graph
            const DBTOPIXEL:Number = HEIGHT/(MAX_DB-MIN_DB);    // Pixels/tick
            const FREQTOPIXEL:Number = WIDTH/(MAX_FREQ-MIN_FREQ);// Pixels/Hz 
            //-----------------------            
            
            var i:uint;
            var numPoints:uint;
            
            numPoints = mMag.length;
            if ( mMag.length != mFreq.length )trace( "mMag.length != mFreq.length" );
            
            graphics.clear();

            // Draw a rectangular box marking the boundaries of the graph
            graphics.lineStyle( 1, 0xcccccc );
            graphics.drawRect( LEFT, TOP, WIDTH, HEIGHT );
            graphics.moveTo(LEFT, TOP+HEIGHT);

            // Tick marks on the vertical axis            
            var y:Number;
            var x:Number;
           
            // The line in the graph
            // Ignore points that are too far to the left
            for ( i = 0; i < numPoints && mFreq[i] < MIN_FREQ; i++ )
            {
            }

            // For all remaining points within range of x-axis            
            var firstPoint:Boolean = true;
            for ( /**/; i < numPoints && mFreq[i] <= MAX_FREQ; i++ )
            {
                // Compute horizontal position
                x = LEFT + FREQTOPIXEL*(mFreq[i]-MIN_FREQ);
            
                // Compute vertical position of point
                // and clip at top/bottom.
                y = BOTTOM - DBTOPIXEL*(mMag[i]-MIN_DB);
                if ( y < TOP )
                    y = TOP;
                else if ( y > BOTTOM )
                    y = BOTTOM;

                // If it's the first point                
                if ( firstPoint )
                {
                    // Move to the point
                    graphics.moveTo(x,y);
                    firstPoint = false;
                }
                else
                {
                    // Otherwise, draw line from the previous point
                    graphics.lineTo(x,y);
                }
                
            }

        }         
    }
}