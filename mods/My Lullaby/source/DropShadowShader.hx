// Obtained from V-Slice, adapted by Remagets :]
import flixel.math.FlxAngle;

class DropShadowShader {
/**
    Shader taken from the shaders folder
  **/
  public var shader:CustomShader = new CustomShader('dropShadow');
  
  /*
    The color of the drop shadow.
   */
  public var color(default, set):FlxColor;

  /*
    The angle of the drop shadow.

    for reference, depending on the angle, the affected side will be:
    0 = RIGHT
    90 = UP
    180 = LEFT
    270 = DOWN
   */
  public var angle(default, set):Float;

  /*
    The distance or size of the drop shadow, in pixels,
    relative to the texture itself... NOT the camera.
   */
  public var distance(default, set):Float;

  /*
    The strength of the drop shadow.
    Effectively just an alpha multiplier.
   */
  public var strength(default, set):Float;

  /*
    The brightness threshold for the drop shadow.
    Anything below this number will NOT be affected by the drop shadow shader.
    A value of 0 effectively means theres no threshold, and vice versa.
   */
  public var threshold(default, set):Float;

  /*
    The amount of antialias samples per-pixel,
    used to smooth out any hard edges the brightness thresholding creates.
    Defaults to 2, and 0 will remove any smoothing.
   */
  public var antialiasAmt(default, set):Float;

  /*
    Whether the shader should try and use the alternate mask.
    False by default.
   */
  public var useAltMask(default, set):Bool;

  /*
    The image for the alternate mask.
    At the moment, it uses the blue channel to specify what is or isnt going to use the alternate threshold.
    (its kinda sloppy rn i need to make it work a little nicer)
    TODO: maybe have a sort of "threshold intensity texture" as well? where higher/lower values indicate threshold strength..
   */
  public var altMaskImage(default, set):BitmapData;

  /*
    An alternate brightness threshold for the drop shadow.
    Anything below this number will NOT be affected by the drop shadow shader,
    but ONLY when the pixel is within the mask.
   */
  public var maskThreshold(default, set):Float;

  /*
    The FlxSprite that the shader should get the frame data from.
    Needed to keep the drop shadow shader in the correct bounds and rotation.
   */
  public var attachedSprite (default, set):FlxSprite;

  /*
    The hue component of the Adjust Color part of the shader.
   */
  public var baseHue(default, set):Float;

  /*
    The saturation component of the Adjust Color part of the shader.
   */
  public var baseSaturation(default, set):Float;

  /*
    The brightness component of the Adjust Color part of the shader.
   */
  public var baseBrightness(default, set):Float;

  /*
    The contrast component of the Adjust Color part of the shader.
   */
  public var baseContrast(default, set):Float;

  /*
    The zoom component of the shader.
   */
  public var baseZoom(default, set):Float;

  /*
    Whether the shader should use pixel perfect mode.
   */
  public var pixelPerfect(default, set):Bool;

  /*
    Whether the shader should flip the sprite horizontally.
   */
  public var flipX(default, set):Bool;

  /*
    Whether the shader should flip the sprite vertically.
   */
  public var flipY(default, set):Bool;

  function new(
    sprite:FlxSprite, color:Array<Float>, ang:Float, dist:Float, str:Float, thr:Float, 
    ?hue:Float, ?saturation:Float, ?brightness:Float, ?contrast:Float, 
    ?AA:Float, ?zoom:Float, ?pixelPerfect:Bool, ?flipX:Bool, ?flipY:Bool) {
        if(sprite == null) return "No sprite specified, shader can not be applied";

        this.attachedSprite = sprite;
        attachedSprite.shader = shader;

        this.angle = ang != null ? ang : 0;
        this.distance = dist != null ? dist : 10;
        this.strength = str != null ? str : 1;
        this.threshold = thr != null ? thr : 0.1;

        this.antialiasAmt = AA != null ? AA : 2;

        this.baseHue = hue != null ? hue : 0;
        this.baseSaturation = saturation != null ? saturation : 0;
        this.baseBrightness = brightness != null ? brightness : 1;
        this.baseContrast = contrast != null ? contrast : 1;

        this.baseZoom = zoom != null ? zoom : 1;
        this.pixelPerfect = pixelPerfect != null ? pixelPerfect : false;
        this.flipX = flipX != null ? flipX : false;
        this.flipY = flipY != null ? flipY : false;

        this.color = color;
        //setAdjustColor(baseBrightness, baseHue, baseContrast, baseSaturation);
        setDropShadowColor(color[0], color[1], color[2]);   
        updateFrameInfo(attachedSprite.frame);

        attachedSprite?.animation?.onFrameChange.add(function() {
          updateFrameInfo(attachedSprite.frame);
        });
    }

    public function updateFrameInfo(frame) {
        frame ??= attachedSprite.frame;
        var uv = frame?.uv;
        if(frame == null) {
          attachedSprite.shader.uFrameBounds = [1, 1, 1, 1];
          attachedSprite.shader.angOffset = 1;
          threshold = 0.3;
          return;
        }
        
        attachedSprite.shader.uFrameBounds = [uv.x, uv.y, uv.width, uv.height];
        attachedSprite.shader.angOffset = frame.angle;
    }

    public function postUpdate(elapsed:Float) {
        updateFrameInfo(attachedSprite.frame);
    }

    public function setAdjustColor(h:Float, s:Float, b:Float,  c:Float) {
      baseBrightness = b;
      baseHue = h;
      baseContrast = c;
      baseSaturation = s;
    }

    public function setDropShadowColor(r:Float, g:Float, b:Float) {
        color = [r / 255, g / 255, b / 255];
    }

    public function set_color(targColor:Array<Float>) {
        attachedSprite.shader.dropColor = color = targColor;
        return targColor;
    }

    public function set_angle(ang:Float) {
        angle = ang;
        attachedSprite.shader.ang = FlxAngle.asRadians(angle);
        return ang;
    }

    public function set_distance(dist:Float) {
        attachedSprite.shader.dist = distance = dist;
        return dist;
    }

    public function set_strength(str:Float) {
        attachedSprite.shader.str = strength = str;
        return str;
    }

    public function set_threshold(thr:Float) {
        attachedSprite.shader.thr = threshold = thr;
        return thr;
    }

    public function set_antialiasAmt(AA:Float) {
        attachedSprite.shader.AA_STAGES = antialiasAmt = AA;
        return AA;
    }

    public function set_baseHue(val:Float) {
        attachedSprite.shader.hue = baseHue = val;
        return val;
    }

    public function set_baseSaturation(val:Float) {
        attachedSprite.shader.saturation = baseSaturation = val;
        return val;
    }

    public function set_baseContrast(val:Float) {
        attachedSprite.shader.contrast = baseContrast = val;
        return val;
    }

    public function set_baseBrightness(val:Float) {
        attachedSprite.shader.brightness = baseBrightness = val;
        return val;
    }

    public function set_useAltMask(useAltMask:Bool) {
        attachedSprite.shader.altMask = useAltMask = useAltMask;
        return useAltMask;
    }

    public function set_maskThreshold(maskThreshold:Float) {
        attachedSprite.shader.thr2 = maskThreshold = maskThreshold;
        return maskThreshold;
    }

    public function set_attachedSprite(spr:FlxSprite) {
        attachedSprite = spr;
        if(attachedSprite.shader != null) updateFrameInfo(attachedSprite.frame);
        return spr;
    }

    public function set_baseZoom(zoom:Float) {
        attachedSprite.shader.zoom = baseZoom = zoom;
        return zoom;
    }

    public function set_pixelPerfect(pixelPerfect:Bool) {
        attachedSprite.shader.pixelPerfect = this.pixelPerfect = pixelPerfect;
        return pixelPerfect;
    }

    public function set_flipX(flipX:Bool) {
        attachedSprite.shader.flipX = this.flipX = flipX;
        return flipX;
    }

    public function set_flipY(flipY:Bool) {
        attachedSprite.shader.flipY = this.flipY = flipY;
        return flipY;
    }
}