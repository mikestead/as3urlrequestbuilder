

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import mx.controls.DataGrid;
import mx.controls.Button;
import mx.containers.Form;
import mx.controls.TextInput;

class BindableProperty
{
	/**
	 * generated bindable wrapper for property filesGrid (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'filesGrid' moved to '_1299143075filesGrid'
	 */

    [Bindable(event="propertyChange")]
    public function get filesGrid():mx.controls.DataGrid
    {
        return this._1299143075filesGrid;
    }

    public function set filesGrid(value:mx.controls.DataGrid):void
    {
    	var oldValue:Object = this._1299143075filesGrid;
        if (oldValue !== value)
        {
            this._1299143075filesGrid = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "filesGrid", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property mainForm (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'mainForm' moved to '_8846819mainForm'
	 */

    [Bindable(event="propertyChange")]
    public function get mainForm():mx.containers.Form
    {
        return this._8846819mainForm;
    }

    public function set mainForm(value:mx.containers.Form):void
    {
    	var oldValue:Object = this._8846819mainForm;
        if (oldValue !== value)
        {
            this._8846819mainForm = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "mainForm", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property submitBtn (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'submitBtn' moved to '_348630820submitBtn'
	 */

    [Bindable(event="propertyChange")]
    public function get submitBtn():mx.controls.Button
    {
        return this._348630820submitBtn;
    }

    public function set submitBtn(value:mx.controls.Button):void
    {
    	var oldValue:Object = this._348630820submitBtn;
        if (oldValue !== value)
        {
            this._348630820submitBtn = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "submitBtn", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property userAge (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'userAge' moved to '_147161804userAge'
	 */

    [Bindable(event="propertyChange")]
    public function get userAge():mx.controls.TextInput
    {
        return this._147161804userAge;
    }

    public function set userAge(value:mx.controls.TextInput):void
    {
    	var oldValue:Object = this._147161804userAge;
        if (oldValue !== value)
        {
            this._147161804userAge = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "userAge", oldValue, value));
        }
    }

	/**
	 * generated bindable wrapper for property userName (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'userName' moved to '_266666762userName'
	 */

    [Bindable(event="propertyChange")]
    public function get userName():mx.controls.TextInput
    {
        return this._266666762userName;
    }

    public function set userName(value:mx.controls.TextInput):void
    {
    	var oldValue:Object = this._266666762userName;
        if (oldValue !== value)
        {
            this._266666762userName = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "userName", oldValue, value));
        }
    }



}
