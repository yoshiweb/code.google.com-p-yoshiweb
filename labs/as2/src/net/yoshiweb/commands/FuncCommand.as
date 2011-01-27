﻿/* *  *  */import mx.events.EventDispatcher;import jp.cellfusion.commands.Command;import jp.cellfusion.commands.ICommand;import jp.cellfusion.commands.events.CommandEvent;class net.yoshiweb.commands.FuncCommand extends Command implements ICommand {		private var _thisObj:Object;	private var _funcRef;	private var _args:Array;	private var _eventDispatcher:EventDispatcher;		private var _eventType:String;		/**	 * 関数を実行するコマンド	 * <pre>	 * // 通常はこんな風に使う	 * var cmd:FuncCommand = new FuncCommand(null, trace, ["hoge"]);	 * cmd.execute();	 * 	 * // 文字列でも関数を指定できる	 * var cmd:FuncCommand = new FuncCommand(null, "trace", ["fuga"]);	 * cmd.execute();	 * </pre>	 * @param thisObj 関数を実行するスコープ	 * @param funcRef 実行する関数	 * @param args    関数に渡す引数	 * @param eventType イベント名	 */	public function FuncCommand(thisObj:Object, funcRef, args:Array, eventType:String) 	{		_eventDispatcher = new EventDispatcher();				_thisObj = thisObj;		_funcRef = funcRef;		_args = args;				_eventType = eventType;	}	/**	 * 実行	 */	public function execute():Void 	{		var func:Function		if (_thisObj == null) {			func = typeof(_funcRef) == "string" ? _global[_funcRef] : _funcRef;		} else {			func = typeof(_funcRef) == "string" ? _thisObj[_funcRef] : _funcRef;		}				if ( _eventType ) {			_thisObj.addEventListener(_eventType, this, "_eventHandler");		}		func.apply(_thisObj, _args);				if ( !_eventType ) {			dispatchEvent(new CommandEvent(CommandEvent.COMMAND_PROGRESS, this));			dispatchEvent(new CommandEvent(CommandEvent.COMMAND_COMPLETE, this));		}	}		private function _eventHandler (e:Object):Void {		_thisObj.removeEventListener(_eventType, this, "_eventHandler");		dispatchEvent(new CommandEvent(CommandEvent.COMMAND_PROGRESS, this));		dispatchEvent(new CommandEvent(CommandEvent.COMMAND_COMPLETE, this));	}				public function clone():ICommand 	{		return new FuncCommand(_thisObj, _funcRef, _args);	}	public function abort():Void 	{	}	public function resume():Void 	{	}	/**	 * 	 */	function toString() 	{		return "[object FuncCommand]";	}	/**	 * 初期化処理	 */	private function initialize():Void	{	}	private function arrayContains(arr:Array, obj:Object):Boolean	{		var index = getItemIndex(arr, obj);		return (index >= 0);	}	private function getItemIndex(arr:Array, obj:Object):Number	{		for (var i = 0;i < arr.length; i++) if (arr[i] === obj) return i; 		return -1;	}	public function addEventListener(event:String, handler:Object):Void	{		_eventDispatcher.addEventListener(event, handler);	}	public function removeEventListener(event:String, handler:Object):Void	{		_eventDispatcher.removeEventListener(event, handler);	}	private function dispatchEvent(event:CommandEvent):Void	{		_eventDispatcher.dispatchEvent(event);	}}