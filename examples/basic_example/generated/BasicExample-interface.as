
package 
{
import flash.accessibility.*;
import flash.debugger.*;
import flash.display.*;
import flash.errors.*;
import flash.events.*;
import flash.external.*;
import flash.filters.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.printing.*;
import flash.profiler.*;
import flash.system.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;
import flash.xml.*;
import mx.binding.*;
import mx.containers.Form;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.core.Application;
import mx.core.ClassFactory;
import mx.core.DeferredInstanceFromClass;
import mx.core.DeferredInstanceFromFunction;
import mx.core.IDeferredInstance;
import mx.core.IFactory;
import mx.core.IPropertyChangeNotifier;
import mx.core.mx_internal;
import mx.styles.*;
import mx.containers.HBox;
import mx.controls.Button;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.containers.VBox;
import mx.containers.FormItem;
import mx.containers.FormHeading;
import mx.core.Application;

public class BasicExample extends mx.core.Application
{
	public function BasicExample() {}

	[Bindable]
	public var mainForm : mx.containers.Form;
	[Bindable]
	public var userName : mx.controls.TextInput;
	[Bindable]
	public var userAge : mx.controls.TextInput;
	[Bindable]
	public var filesGrid : mx.controls.DataGrid;
	[Bindable]
	public var submitBtn : mx.controls.Button;

	mx_internal var _bindings : Array;
	mx_internal var _watchers : Array;
	mx_internal var _bindingsByDestination : Object;
	mx_internal var _bindingsBeginWithWord : Object;

include "C:/workspaces/flash/urlrequestbuilder/examples/basic_example/BasicExample.mxml:4,144";

}}
