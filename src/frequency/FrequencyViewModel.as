﻿package frequency{    import flash.display.Sprite;    import frequency.FrequencyModel;    import frequency.FrequencyView;    import flash.events.Event;    import __AS3__.vec.Vector;    //import flash.events.EventDispatcher;        public class FrequencyViewModel extends Sprite    {        private var mModel:FrequencyModel;        private var mView:FrequencyView;        private var m_mag:Vector.<Number>;            // Magnitudes (at each of the frequencies below)        private var m_freq:Vector.<Number>;            // Frequencies (for each of the magnitudes above)         private var mLowSum:Number = 0;        private var mMedSum:Number = 0;        private var mHighSum:Number = 0;        private var mBeatSum:Number = 0;        public static var UPDATE_SPECTRUM:String = 'spectrumUpdate';        public static var UPDATE_LOW_SUM:String = 'low freq sum update';        public static var UPDATE_MID_SUM:String = 'mid freq sum update';        public static var UPDATE_HIGH_SUM:String = 'high freq sum update';        public static var UPDATE_BEAT_SUM:String = 'beat freq sum update';                public function FrequencyViewModel()        {            trace("FrequencyViewModel.FrequencyViewModel()");        }        public function Init(FreqModel:FrequencyModel, FreqView:FrequencyView):void        {            mModel          = FreqModel;            mView           = FreqView;        }        // barArr[i].id, barArr[i].x, barArr[i].y, barArr[i].width, barArr[i].height        public function setRangeValue(FreqRange:String, x:Number, y:Number, h:Number, w:Number):void        {            trace("x:"+ x);            var tL:Array = [x, y];            var bL:Array = [x, h];            var tR:Array = [(w + x), y];            var bR:Array = [w, h];            mModel.SetFreqSampleArea(FreqRange, tL, bL, tR, bR );           //trace("mModel:"+mModel);            //send formatted data to model to ping back and dispatch to view        }                        /////////////////////        //// GET AND SET ////        /////////////////////               // frequency and magnitude of spectrum        public function get mag ():Vector.<Number>        {            return m_mag;        }         public function set mag(v:Vector.<Number>):void        {            m_mag = v;            dispatchEvent(new Event(FrequencyViewModel.UPDATE_SPECTRUM));        }        public function get freq ():Vector.<Number>        {            return m_freq;        }        public function set freq(v:Vector.<Number>):void        {            m_freq = v;            dispatchEvent(new Event(FrequencyViewModel.UPDATE_SPECTRUM));        }        //low averaged/sum frequency        public function get lSum():Number        {            return mLowSum        }        public function set lSum(s:Number):void        {            mLowSum = s;            dispatchEvent(new Event(FrequencyViewModel.UPDATE_LOW_SUM));        }                //mid averaged/sum frequency        public function get mSum():Number        {            return mMedSum        }        public function set mSum(s:Number):void        {            mMedSum = s;            dispatchEvent(new Event(FrequencyViewModel.UPDATE_MID_SUM));        }                //high averaged/sum frequency        public function get hSum():Number        {            return mHighSum        }        public function set hSum(s:Number):void        {            mHighSum = s;            dispatchEvent(new Event(FrequencyViewModel.UPDATE_HIGH_SUM));        }        //high averaged/sum frequency        public function get bSum():Number        {            return mBeatSum;        }        public function set bSum(s:Number):void        {            mBeatSum = s;            dispatchEvent(new Event(FrequencyViewModel.UPDATE_BEAT_SUM));        }    }}