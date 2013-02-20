package util 
{
	/**
     * ...
     * @author Dermot
     */
    
    import flash.display.MovieClip;
    import flash.geom.ColorTransform;

    public class ColorUtil 
    {
        

        
        public static function ChangeColor(movieClip:MovieClip, color:Number):void
        {

            var myColorTransform = new ColorTransform();
            myColorTransform.color = color;
            movieClip.transform.colorTransform = myColorTransform;

            
            
        } 
        
       /*  public static function HexToTransform(hex:Number):Object
        {
        //trace(TRACE_STRING + "HexToTransform() --> hex = " + hex);

        // convert from hex to rgb
        var multiplier:Number = MAX_RGB / 255;
        var red:Number   = ((hex & 0xFF0000) >> 16) * multiplier;
        var green:Number = ((hex & 0xFF00) >> 8) * multiplier;
        var blue:Number  = ((hex & 0xFF) >> 0) * multiplier;

        // create an object to pass to the setTransform() method of the Color object
        // assign color values as properties of the object
        // more info on the Color object and its methods can be found in the Flash help docs
        return { ra: red, ga : green, ba: blue };
        }*/
       
    }

}