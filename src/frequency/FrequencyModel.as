package frequency
{
    import __AS3__.vec.Vector;
    
    import flash.display.Sprite;
    import flash.events.*;
    import flash.media.Microphone;
    import flash.utils.*;
    
    import frequency.FrequencyViewModel;
    import frequency.soundAnalysis.FFT2;
    import frequency.soundAnalysis.FFTElement;
 
    /**
     * A real-time spectrum analyzer.
     * 
     * Released under the MIT License
     *
     * Copyright (c) 2010 Gerald T. Beauregard
     *
     * Permission is hereby granted, free of charge, to any person obtaining a copy
     * of this software and associated documentation files (the "Software"), to
     * deal in the Software without restriction, including without limitation the
     * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
     * sell copies of the Software, and to permit persons to whom the Software is
     * furnished to do so, subject to the following conditions:
     *
     * The above copyright notice and this permission notice shall be included in
     * all copies or substantial portions of the Software.
     *
     * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
     * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
     * IN THE SOFTWARE.
     */
    

    public class FrequencyModel extends Sprite
    {
        /////////////////////
        //// INSTANCES //////
        /////////////////////
        
        /////////////////////
        //// CONSTANTS //////
        /////////////////////
        private const SAMPLE_RATE:Number    = 22050;    // Actual microphone sample rate (Hz)
        private const LOGN:uint             = 11;       // Log2 FFT length
        private const N:uint = 1 << LOGN;               // FFT Length
        private const BUF_LEN:uint          = N;        // Length of buffer for mic audio
        private const UPDATE_PERIOD:int     = 50;       // Period of spectrum updates (ms)
        private const DB_OFFSET:Number             = 90;
        private const DB_INC:Number                = 100 / DB_OFFSET;
        
        /////////////////////
        //// MEMBER VARS ////
        /////////////////////
        private var m_fft:FFT2;                         // FFT object
        private var m_tempRe:Vector.<Number>;           // Temporary buffer - real part
        private var m_tempIm:Vector.<Number>;           // Temporary buffer - imaginary part
        public  var m_mag:Vector.<Number>;               // Magnitudes (at each of the frequencies below)
        public  var m_freq:Vector.<Number>;              // Frequencies (for each of the magnitudes above) 
        private var m_win:Vector.<Number>;              // Analysis window (Hanning)
        private var m_mic:Microphone;                   // Microphone object
        private var m_writePos:uint         = 0;        // Position to write new audio from mic
        private var m_buf:Vector.<Number>   = null;     // Buffer for mic audio
        private var m_timer:Timer;                      // Timer for updating spectrum
        private var mViewModel:FrequencyViewModel;
        
        //Default frequency values 0 = topLeft, 1 = bottomLeft, 2 = topRight, 3 = bottomRight 
        private var mSpecWidth:Number;
        private var mSpecHeight:Number;
        private var mLowPointArr:Array   = [[0,0],[0,0],[0,0],[0,0]]; 
        private var mMidPointArr:Array   = [[0,0],[0,0],[0,0],[0,0]]; 
        private var mHighPointArr:Array  = [[0,0],[0,0],[0,0],[0,0]]; 
        private var mBeatPointArr:Array  = [[0,0],[0,0],[0,0],[0,0]]; 
        private var mFreqWidthInc:Number;

        /////////////////////
        //// STATIC VARS ////
        /////////////////////    
        

        public function FrequencyModel()
        {
            trace("FrequencyModel.FrequencyModel()");
            
        }
        
        public function Init(FreqViewModel:FrequencyViewModel, h:Number, w:Number):void
        {
            mViewModel      = FreqViewModel;
            mSpecHeight     = h;
            mSpecWidth      = w;
            mFreqWidthInc     = 1024 / w;
            
            var i:uint;
            
            // Set up the FFT
            m_fft = new FFT2();
            m_fft.init(LOGN);
            m_tempRe = new Vector.<Number>(N);
            m_tempIm = new Vector.<Number>(N);
            m_mag = new Vector.<Number>(N/2);

            // Vector with frequencies for each bin number. Used 
            // in the graphing code (not in the analysis itself  ).            
            m_freq = new Vector.<Number>(N/2);
            for ( i = 0; i < N/2; i++ )
                m_freq[i] = i*SAMPLE_RATE/N;
            
            // Hanning analysis window
            m_win = new Vector.<Number>(N);
            for ( i = 0; i < N; i++ )
                m_win[i] = (4.0/N) * 0.5*(1-Math.cos(2*Math.PI*i/N));
                
            // Create a buffer for the input audio
            m_buf = new Vector.<Number>(BUF_LEN);
            for ( i = 0; i < BUF_LEN; i++ )
                m_buf[i] = 0.0;

            // Set up microphone inpu t
            m_mic = Microphone.getMicrophone();
            m_mic.rate = SAMPLE_RATE/1000;        
            m_mic.setSilenceLevel(0.0);            // Have the mic run non-stop, regardless of the input level
            m_mic.addEventListener( SampleDataEvent.SAMPLE_DATA, onMicSampleData );

            // Set up a timer to do periodic updates of the spectrum        
            m_timer = new Timer(UPDATE_PERIOD);
            m_timer.addEventListener(TimerEvent.TIMER, updateSpectrum);
            m_timer.start();
        }

        public function SetFreqSampleArea(s:String, tL:Array, bL:Array, tR:Array, bR:Array):void
        {
            //Default frequency values 1 = topLeft, 2 = bottomLeft, 3 = topRight, 4 = bottomRight 
            //trace("tL:" + tL);
            this["m" + s + "PointArr"][0] = tL;
            this["m" + s + "PointArr"][1] = bL;
            this["m" + s + "PointArr"][2] = tR;
            this["m" + s + "PointArr"][3] = bR; 
            _SumFreq();
        }
        private function onMicSampleData( event:SampleDataEvent ):void
        {
            // Get number of available input samples
            var len:uint = event.data.length/4;
            
            // Read the input data and stuff it into 
            // the circular buffer
            for ( var i:uint = 0; i < len; i++ )
            {
                m_buf[m_writePos] = event.data.readFloat();
                m_writePos = (m_writePos+1)%BUF_LEN;
            }
        }
        
        
        //Called at regular intervals to update the spectrum
        private function updateSpectrum( event:Event ):void
        {
            // Copy data from circular microphone audio 
            // buffer into temporary buffer for FFT, while
            // applying Hanning window.
            var i:int;
            var pos:uint = m_writePos;
            for ( i = 0; i < N; i++ )                                                     
            
            {
                m_tempRe[i] = m_win[i]*m_buf[pos];
                pos = (pos+1)%BUF_LEN;
            }
            
            // Zero out the imaginary component
            for ( i = 0; i < N; i++ )
                m_tempIm[i] = 0.0;
            
            // Do FFT and get magnitude spectrum
            m_fft.run( m_tempRe, m_tempIm );
            for ( i = 0; i < N/2; i++ )
            {
                var re:Number = m_tempRe[i];
                var im:Number = m_tempIm[i];
                m_mag[i] = Math.sqrt(re*re + im*im);
            }
            
            // Convert to dB magnitude
            const SCALE:Number = 20 / Math.LN10; 
            for ( i = 0; i < N/2; i++ )
            {
                // 20 log10(mag) => 20/ln(10) ln(mag)
                // Addition of MIN_VALUE prevents log from returning minus infinity if mag is zero
                m_mag[i] = SCALE*Math.log( m_mag[i] + Number.MIN_VALUE );
            }
            mViewModel.mag  =    m_mag;
            mViewModel.freq =   m_freq;
            //mViewModel.mSum =    
            _SumFreq();
        }
        private function _SumFreq():void
        {
            var lRawVal:Number = mLowPointArr[0][0];
            var rRawVal:Number = mLowPointArr[2][0];
            //trace("lVal:" + lVal + " rVal:" + rVal);
            //trace("lRawVal:" + (lVal * mFreqWidthInc) + " rRawVal:" + (rVal * mFreqWidthInc));
           var lX:Number = (lRawVal > 0) ? Math.round(lRawVal * mFreqWidthInc):0;
           var rX:Number = ((rRawVal * mFreqWidthInc) < 1024) ? Math.round(rRawVal * mFreqWidthInc):1024;
           var add:Number = 0;
           for (var i:int = lX; i < rX; i++) 
           {
                add += m_mag[i];
           }
           var sum:Number = Math.round((DB_OFFSET + add / (rX - lX)) * DB_INC);
           trace(sum);
           //trace("lX:" + lX+" rRawVal:" + rRawVal+" rX:" + rX);
        }
    }
}