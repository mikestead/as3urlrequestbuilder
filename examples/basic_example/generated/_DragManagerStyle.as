
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.skins.halo.DefaultDragImage;

[ExcludeClass]

public class _DragManagerStyle
{
    [Embed(_resolvedSource='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragReject', source='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='655', _pathsep='true', _file='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragReject_611102944:Class;
    [Embed(_resolvedSource='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragMove', source='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='654', _pathsep='true', _file='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragMove_2095397026:Class;
    [Embed(_resolvedSource='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragLink', source='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='653', _pathsep='true', _file='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragLink_2095422283:Class;
    [Embed(_resolvedSource='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', symbol='mx.skins.cursor.DragCopy', source='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', _line='651', _pathsep='true', _file='C:/Program Files/Adobe/Flex Builder 3/sdks/3.2.0/frameworks/libs/framework.swc$defaults.css')]
    private static var _embed_css_Assets_swf_mx_skins_cursor_DragCopy_2096733126:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("DragManager");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("DragManager", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.copyCursor = _embed_css_Assets_swf_mx_skins_cursor_DragCopy_2096733126;
                this.moveCursor = _embed_css_Assets_swf_mx_skins_cursor_DragMove_2095397026;
                this.rejectCursor = _embed_css_Assets_swf_mx_skins_cursor_DragReject_611102944;
                this.linkCursor = _embed_css_Assets_swf_mx_skins_cursor_DragLink_2095422283;
                this.defaultDragImageSkin = mx.skins.halo.DefaultDragImage;
            };
        }
    }
}

}
