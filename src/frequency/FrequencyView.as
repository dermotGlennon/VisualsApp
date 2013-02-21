package frequency
{
    import __AS3__.vec.Vector;
    import com.senocular.display.transform.*;
    import components.HorizTextButtons;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import frequency.freqBar.FreqBar;
    import frequency.FrequencyViewModel;


    public class FrequencyView extends MovieClip
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////
        public var tt_Tool:TransformTool;
        public var fb_MidFreq:FreqBar;
        public var fb_LowFreq:FreqBar;
        public var fb_HighFreq:FreqBar;
        public var fb_BeatBar:FreqBar;
        private var htb_control:HorizTextButtons;
        
        
        /////////////////////   
        //// MEMBER VARS ////
        /////////////////////
        private var m_ViewModel:FrequencyViewModel;
        private var m_Mag:Vector.<Number>;
        private var m_Freq:Vector.<Number>;
        private var m_BarArr:Array;
        private var m_SpecH:Number;
        private var m_SpecW:Number;
        private var m_CtrlBtnParams:Array;
        private var m_CtrlBtnCallBack:Function;
        
        
        /////////////////////
        //// STATIC VARS ////
        /////////////////////
        private static var FREQ_MIN_H_W:Number = 50;
        
        public function FrequencyView()
        {
            trace("FrequencyView.FrequencyView()");
           
            super();
        }
        
        public function Init(FreqViewModel:FrequencyViewModel, SpectrumHeight:Number, SpectrumWidth:Number, ControlButtonParams:Array):void
        {
            m_ViewModel      = FreqViewModel;
            m_SpecH      = SpectrumHeight;
            m_SpecW      = SpectrumWidth;
            m_CtrlBtnParams = ControlButtonParams;
            tt_Tool   = new TransformTool(new ControlSetScaleCorners());
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }
        
        private function onAddedToStage(e:Event):void
        {
            trace("FrequencyView.onAddedToStage()");
            fb_LowFreq   = new FreqBar( { Id:"Low", Height:160, Width:264,  X:1, Y:235, Alpha:.2, childUseMouse:false,  Color:0xff0000, SpectrumHeight:m_SpecH } ); 
            fb_MidFreq   = new FreqBar( { Id:"Mid", Height:160, Width:264, X:266, Y:235, Alpha:.2,childUseMouse:false,  Color:0x00ff00, SpectrumHeight:m_SpecH } ); 
            fb_HighFreq  = new FreqBar( { Id:"High", Height:160, Width:264, X:534, Y:235, Alpha:.2, childUseMouse:false, Color:0x00ffff, SpectrumHeight:m_SpecH } );
            fb_BeatBar   = new FreqBar( { Id:"Beat", Height:100, Width:793,  X:5, Y:105, Alpha:.2, childUseMouse:false, Color:0xffffff, SpectrumHeight:m_SpecH } );
            m_BarArr      = [fb_LowFreq, fb_MidFreq, fb_HighFreq, fb_BeatBar];
            
            // create and set up the transform tool
            tt_Tool.addChild(new ControlReset());
            var removeReg:ControlRegistration = new ControlRegistration();
            removeReg.editable = false;
            tt_Tool.addChild(removeReg);
            tt_Tool.autoRaise         = true;
            tt_Tool.maxHeight         = m_SpecH;
            tt_Tool.maxWidth          = m_SpecW;
            tt_Tool.negativeScaling   = false;
            tt_Tool.minHeight         = FREQ_MIN_H_W;
            tt_Tool.minWidth          = FREQ_MIN_H_W;
            addChild(tt_Tool);
            
            // create and set the frequency controls
            htb_control = new HorizTextButtons( { ButtonArr:m_CtrlBtnParams } );
            htb_control.x = 400;
            htb_control.y = -23;
            htb_control.addEventListener(HorizTextButtons.BUTTON_HIT, _BtnHit);
            addChild(htb_control)
            
            
            
            
            // add/remove listeners
            m_ViewModel.addEventListener(FrequencyViewModel.UPDATE_SPECTRUM, _AudioData);
          
            
            tt_Tool.addEventListener(TransformTool.TRANSFORM_CHANGED,_BarTransforming);
            stage.addEventListener(MouseEvent.MOUSE_UP, tt_Tool.deselect);
            addEventListener(MouseEvent.MOUSE_DOWN, tt_Tool.select);
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            _SetInitialBarVals();//TODO get from xml 
        }
        
        private function _BarTransforming(e:Event):void
        {
            //trace("BARTRANSFORMING");
            var mc:MovieClip = e.target.target;
            //limitStageBorder(mc, e);
            //trace(mc.id + " :" + mc.height);
            m_ViewModel.setRangeValue(  mc.id, mc.x, mc.y, mc.height, mc.width );
            
        }
     
        private function _SetInitialBarVals():void
        {
            for (var i:int = 0; i < m_BarArr.length; i++) 
            {
               m_ViewModel.setRangeValue( m_BarArr[i].id, m_BarArr[i].x, m_BarArr[i].y, m_BarArr[i].height, m_BarArr[i].width );
               addChild(m_BarArr[i]);
            }
        }
        
        private function limitStageBorder(mc:MovieClip, e:Event):void
        {

            /*var mcWidth:uint = mc.width;
            var mcHeight:uint = mc.height;
            
            if (mc.x + mc.width > m_SpecW) 
            {
                trace("out Right");
                tt_Tool.deselect(e);
                mc.x = m_SpecW - (mcWidth + 2);
            }
            else if (mc.x  < 0) 
            {
                trace("out Left");
                mc.x = 2;
                tt_Tool.deselect(e);
            }
            
            if (mc.y < 0) 
            {
                trace("out Top");
                mc.y = 2; 
                tt_Tool.deselect(e);
            }
            else if (mc.y + mcHeight > m_SpecH) 
            {
                trace("out Bottom");
                mc.y = m_SpecH - (mcHeight + 2);
                tt_Tool.deselect(e);
            }*/
        }
        
        private function _AudioData(e:Event):void
        {
            fb_LowFreq.DrawFill(m_ViewModel.lSum, m_ViewModel.lH);
            fb_MidFreq.DrawFill(m_ViewModel.mSum, m_ViewModel.mH);
            fb_HighFreq.DrawFill(m_ViewModel.hSum, m_ViewModel.hH);
            fb_BeatBar.DrawFill(m_ViewModel.bSum, m_ViewModel.bH);
            _SpectrumUpdate();
        }
        
        private function _BtnHit(e:Event):void 
        {
             trace("FrequencyView:"+e.currentTarget.bttnHit);
        }
        
        private function _SpectrumUpdate():void
        {
            if (m_ViewModel.mag && m_ViewModel.freq == null) 
            {
                return;
            }
            m_Mag        = m_ViewModel.mag;
            m_Freq       = m_ViewModel.freq;
           
            // Basic constants
            const MIN_FREQ:Number   = 10;// Minimum frequency (Hz) on horizontal axis.
            const MAX_FREQ:Number   = 4000;// Maximum frequency (Hz) on horizontal axis.
            const FREQ_STEP:Number  = 500;// Interval between ticks (Hz) on horizontal axis.
            const MAX_DB:Number     = -0.0;// Maximum dB magnitude on vertical axis.
            const MIN_DB:Number     = -60.0;// Minimum dB magnitude on vertical axis.
            const DB_STEP:Number    = 10;// Interval between ticks (dB) on vertical axis.
            const TOP:Number        = 0;// Top of graph
            const LEFT:Number       = 0;// Left edge of graph
            var HEIGHT:Number       = m_SpecH;// Height of graph
            var WIDTH:Number        = m_SpecW;// Width of graph
            const TICK_LEN:Number   = 10;// Length of tick in pixels
            
            // Derived constants
            const BOTTOM:Number = TOP+HEIGHT;                    // Bottom of graph
            const DBTOPIXEL:Number = HEIGHT/(MAX_DB-MIN_DB);    // Pixels/tick
            const FREQTOPIXEL:Number = WIDTH/(MAX_FREQ-MIN_FREQ);// Pixels/Hz 
            //-----------------------            
            
            var i:uint;
            var numPoints:uint;
            
            numPoints = m_Mag.length;
            if ( m_Mag.length != m_Freq.length )trace( "m_Mag.length != m_Freq.length" );
            
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
            for ( i = 0; i < numPoints && m_Freq[i] < MIN_FREQ; i++ )
            {
            }

            // For all remaining points within range of x-axis            
            var firstPoint:Boolean = true;
            for ( /**/; i < numPoints && m_Freq[i] <= MAX_FREQ; i++ )
            {
                // Compute horizontal position
                x = LEFT + FREQTOPIXEL*(m_Freq[i]-MIN_FREQ);
            
                // Compute vertical position of point
                // and clip at top/bottom.
                y = BOTTOM - DBTOPIXEL*(m_Mag[i]-MIN_DB);
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