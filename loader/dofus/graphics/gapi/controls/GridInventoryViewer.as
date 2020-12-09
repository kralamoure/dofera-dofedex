class dofus.graphics.gapi.controls.GridInventoryViewer extends dofus.graphics.gapi.controls.InventoryViewer
{
	static var CLASS_NAME = "GridInventoryViewer";
	var _bShowKamas = true;
	var _bCheckPlayerPods = false;
	var _bCheckMountPods = false;
	function GridInventoryViewer()
	{
		super();
	}
	function __get__cgGrid()
	{
		return this._cgGrid;
	}
	function __get__currentOverItem()
	{
		return this._oOverItem;
	}
	function __get__checkPlayerPods()
	{
		return this._bCheckPlayerPods;
	}
	function __get__checkMountPods()
	{
		return this._bCheckMountPods;
	}
	function __set__checkPlayerPods(§\x1b\x13§)
	{
		this._bCheckPlayerPods = var2;
		return this.__get__checkPlayerPods();
	}
	function __set__checkMountPods(§\x1b\x14§)
	{
		this._bCheckMountPods = var2;
		return this.__get__checkMountPods();
	}
	function __set__showKamas(§\x15\r§)
	{
		this._bShowKamas = var2;
		this._btnDragKama._visible = this._lblKama._visible = this._mcKamaSymbol._visible = this._mcKamaSymbol2._visible = var2;
		return this.__get__showKamas();
	}
	function init()
	{
		super.init(false,dofus.graphics.gapi.controls.GridInventoryViewer.CLASS_NAME);
	}
	function createChildren()
	{
		this._oDataViewer = this._cgGrid;
		this.addToQueue({object:this,method:this.addListeners});
		super.createChildren();
		this.addToQueue({object:this,method:this.initData});
		this.addToQueue({object:this,method:this.initTexts});
	}
	function addListeners()
	{
		super.addListeners();
		this._cgGrid.addEventListener("dropItem",this);
		this._cgGrid.addEventListener("dragItem",this);
		this._cgGrid.addEventListener("selectItem",this);
		this._cgGrid.addEventListener("overItem",this);
		this._cgGrid.addEventListener("outItem",this);
		this._cgGrid.addEventListener("dblClickItem",this);
		this._btnDragKama.onRelease = function()
		{
			this._parent.askKamaQuantity();
		};
	}
	function initTexts()
	{
		this._lblFilter.text = this.api.lang.getText("EQUIPEMENT");
	}
	function initData()
	{
		this.modelChanged();
		this.kamaChanged({value:this._oKamasProvider.Kama});
	}
	function validateDrop(§\x1e\x0b\x1d§, §\x1e\x19\r§, §\x01\x0e§)
	{
		var4 = Number(var4);
		if(var4 < 1 || _global.isNaN(var4))
		{
			return undefined;
		}
		if(var4 > var3.Quantity)
		{
			var4 = var3.Quantity;
		}
		this.dispatchEvent({type:"dropItem",item:var3,quantity:var4});
	}
	function validateKama(§\x01\x0e§)
	{
		var2 = Number(var2);
		if(var2 < 1 || _global.isNaN(var2))
		{
			return undefined;
		}
		if(var2 > this._oKamasProvider.Kama)
		{
			var2 = this._oKamasProvider.Kama;
		}
		this.dispatchEvent({type:"dragKama",quantity:var2});
	}
	function askKamaQuantity()
	{
		var var2 = this._oKamasProvider.Kama == undefined?0:Number(this._oKamasProvider.Kama);
		var var3 = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:var2,max:var2,params:{targetType:"kama"}});
		var3.addEventListener("validate",this);
	}
	function showOneItem(§\x1e\x1b\x1d§)
	{
		var var3 = 0;
		while(var3 < this._cgGrid.dataProvider.length)
		{
			if(var2 == this._cgGrid.dataProvider[var3].unicID)
			{
				this._cgGrid.setVPosition(var3 / this._cgGrid.visibleColumnCount);
				this._cgGrid.selectedIndex = var3;
				return true;
			}
			var3 = var3 + 1;
		}
		return false;
	}
	function dragItem(§\x1e\x19\x18§)
	{
		if(var2.target.contentData == undefined)
		{
			return undefined;
		}
		this.gapi.removeCursor();
		this.gapi.setCursor(var2.target.contentData);
	}
	function dropItem(§\x1e\x19\x18§)
	{
		var var3 = this.gapi.getCursor();
		if(var3 == undefined)
		{
			return undefined;
		}
		this.gapi.removeCursor();
		var var4 = var3.Quantity;
		if(this.checkPlayerPods)
		{
			var4 = this.api.datacenter.Player.getPossibleItemReceiveQuantity(var3,false);
		}
		else if(this.checkMountPods)
		{
			var4 = this.api.datacenter.Player.getPossibleItemReceiveQuantity(var3,true);
		}
		if(var4 <= 0)
		{
			this.api.kernel.showMessage(this.api.lang.getText("INFORMATIONS"),this.api.lang.getText("SRV_MSG_6"),"ERROR_BOX",{name:undefined});
		}
		else if(var4 > 1)
		{
			var var5 = this.gapi.loadUIComponent("PopupQuantity","PopupQuantity",{value:1,max:var4,params:{targetType:"item",oItem:var3}});
			var5.addEventListener("validate",this);
		}
		else
		{
			this.validateDrop(this._cgGrid,var3,1);
		}
	}
	function selectItem(§\x1e\x19\x18§)
	{
		if(Key.isDown(dofus.Constants.CHAT_INSERT_ITEM_KEY) && var2.target.contentData != undefined)
		{
			this.api.kernel.GameManager.insertItemInChat(var2.target.contentData);
			return undefined;
		}
		this.dispatchEvent({type:"selectedItem",item:var2.target.contentData});
	}
	function overItem(§\x1e\x19\x18§)
	{
		var var3 = var2.target.contentData;
		var3.showStatsTooltip(var2.target,var2.target.contentData.style);
		this._oOverItem = var3;
	}
	function outItem(§\x1e\x19\x18§)
	{
		this.gapi.hideTooltip();
		this._oOverItem = undefined;
	}
	function dblClickItem(§\x1e\x19\x18§)
	{
		this.dispatchEvent({type:var2.type,item:var2.target.contentData,target:this,targets:var2.targets,index:var2.target.id});
	}
	function validate(§\x1e\x19\x18§)
	{
		switch(var2.params.targetType)
		{
			case "item":
				this.validateDrop(this._cgGrid,var2.params.oItem,var2.value);
				break;
			case "kama":
				this.validateKama(var2.value);
		}
	}
}
