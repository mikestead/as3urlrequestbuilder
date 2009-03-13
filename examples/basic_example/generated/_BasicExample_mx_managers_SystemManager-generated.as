package
{

import flash.text.Font;
import flash.text.TextFormat;
import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;

import mx.managers.SystemManager;

public class _BasicExample_mx_managers_SystemManager
    extends mx.managers.SystemManager
    implements IFlexModuleFactory
{
    public function _BasicExample_mx_managers_SystemManager()
    {

        super();
    }

    override     public function create(... params):Object
    {
        if (params.length > 0 && !(params[0] is String))
            return super.create.apply(this, params);

        var mainClassName:String = params.length == 0 ? "BasicExample" : String(params[0]);
        var mainClass:Class = Class(getDefinitionByName(mainClassName));
        if (!mainClass)
            return null;

        var instance:Object = new mainClass();
        if (instance is IFlexModule)
            (IFlexModule(instance)).moduleFactory = this;
        return instance;
    }

    override    public function info():Object
    {
        return {
            applicationComplete: "setup()",
            compiledLocales: [ "en_US" ],
            compiledResourceBundleNames: [ "collections", "containers", "controls", "core", "effects", "skins", "styles" ],
            currentDomain: ApplicationDomain.currentDomain,
            layout: "absolute",
            mainClassName: "BasicExample",
            mixins: [ "_BasicExample_FlexInit", "_richTextEditorTextAreaStyleStyle", "_alertButtonStyleStyle", "_ControlBarStyle", "_FormHeadingStyle", "_FormStyle", "_textAreaVScrollBarStyleStyle", "_headerDateTextStyle", "_globalStyle", "_ListBaseStyle", "_todayStyleStyle", "_AlertStyle", "_windowStylesStyle", "_ApplicationStyle", "_ToolTipStyle", "_FormItemLabelStyle", "_CursorManagerStyle", "_opaquePanelStyle", "_TextInputStyle", "_errorTipStyle", "_dateFieldPopupStyle", "_FormItemStyle", "_dataGridStylesStyle", "_DataGridStyle", "_popUpMenuStyle", "_headerDragProxyStyleStyle", "_activeTabStyleStyle", "_PanelStyle", "_DragManagerStyle", "_ContainerStyle", "_windowStatusStyle", "_ScrollBarStyle", "_swatchPanelTextFieldStyle", "_textAreaHScrollBarStyleStyle", "_plainStyle", "_activeButtonStyleStyle", "_comboDropdownStyle", "_ButtonStyle", "_DataGridItemRendererStyle", "_weekDayStyleStyle", "_linkButtonStyleStyle" ]
        }
    }
}

}
