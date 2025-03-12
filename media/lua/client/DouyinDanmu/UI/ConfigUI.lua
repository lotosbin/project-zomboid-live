-- DouyinDanmu/UI/ConfigUI.lua
-- 抖音弹幕配置界面

require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISTextEntryBox"
require "ISUI/ISLabel"
require "ISUI/ISComboBox"
require "ISUI/ISTickBox"

DouyinDanmu = DouyinDanmu or {}
DouyinDanmu.UI = DouyinDanmu.UI or {}

-- 配置窗口类，继承自ISPanel
DouyinDanmu.UI.ConfigWindow = ISPanel:derive("DouyinDanmu.UI.ConfigWindow")

-- 显示配置窗口
function DouyinDanmu.UI.showConfigWindow()
    -- 如果窗口已经存在，则显示它
    if DouyinDanmu.UI.configWindow then
        DouyinDanmu.UI.configWindow:setVisible(true)
        return
    end
    
    -- 获取屏幕尺寸
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    
    -- 创建配置窗口
    local windowWidth = 400
    local windowHeight = 500
    local windowX = (screenWidth - windowWidth) / 2
    local windowY = (screenHeight - windowHeight) / 2
    
    DouyinDanmu.UI.configWindow = DouyinDanmu.UI.ConfigWindow:new(
        windowX, windowY, windowWidth, windowHeight
    )
    DouyinDanmu.UI.configWindow:initialise()
    DouyinDanmu.UI.configWindow:instantiate()
    DouyinDanmu.UI.configWindow:setVisible(true)
    DouyinDanmu.UI.configWindow:addToUIManager()
end

-- 构造函数
function DouyinDanmu.UI.ConfigWindow:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    
    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.backgroundColor = {r=0.1, g=0.1, b=0.1, a=0.9}
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.moveWithMouse = true
    o.controls = {}
    
    return o
end

-- 初始化
function DouyinDanmu.UI.ConfigWindow:initialise()
    ISPanel.initialise(self)
    self:createControls()
end

-- 创建控件
function DouyinDanmu.UI.ConfigWindow:createControls()
    local y = 20
    local labelWidth = 150
    local controlWidth = 200
    local controlHeight = 25
    local padding = 10
    
    -- 标题
    self:addLabel("抖音弹幕配置", self.width / 2 - 50, y, 1, 1, 1, 1, UIFont.Medium)
    y = y + 30
    
    -- 分隔线
    self:addHorizontalLine(y, 1)
    y = y + 20
    
    -- 基本设置标题
    self:addLabel("基本设置", 20, y, 1, 0.8, 0.8, 1, UIFont.Small)
    y = y + 25
    
    -- 直播间ID
    self:addLabel("直播间ID:", 20, y + 2, 1, 1, 1, 1, UIFont.Small)
    self.controls.roomIdEntry = self:addTextEntryBox(labelWidth, y, controlWidth, controlHeight)
    self.controls.roomIdEntry:setText(DouyinDanmu.getConfig("roomId"))
    y = y + controlHeight + padding
    
    -- 显示位置
    self:addLabel("弹幕位置:", 20, y + 2, 1, 1, 1, 1, UIFont.Small)
    self.controls.positionCombo = self:addComboBox(labelWidth, y, controlWidth, controlHeight)
    self.controls.positionCombo:addOption("右侧")
    self.controls.positionCombo:addOption("左侧")
    self.controls.positionCombo:addOption("顶部")
    self.controls.positionCombo:addOption("底部")
    
    -- 设置当前选中项
    local position = DouyinDanmu.getConfig("displayPosition")
    if position == "right" then
        self.controls.positionCombo.selected = 1
    elseif position == "left" then
        self.controls.positionCombo.selected = 2
    elseif position == "top" then
        self.controls.positionCombo.selected = 3
    elseif position == "bottom" then
        self.controls.positionCombo.selected = 4
    end
    y = y + controlHeight + padding
    
    -- 弹幕数量
    self:addLabel("最大弹幕数:", 20, y + 2, 1, 1, 1, 1, UIFont.Small)
    self.controls.maxDanmuEntry = self:addTextEntryBox(labelWidth, y, controlWidth, controlHeight)
    self.controls.maxDanmuEntry:setText(tostring(DouyinDanmu.getConfig("maxDanmuCount")))
    y = y + controlHeight + padding
    
    -- 弹幕停留时间
    self:addLabel("弹幕停留时间(秒):", 20, y + 2, 1, 1, 1, 1, UIFont.Small)
    self.controls.stayTimeEntry = self:addTextEntryBox(labelWidth, y, controlWidth, controlHeight)
    self.controls.stayTimeEntry:setText(tostring(DouyinDanmu.getConfig("danmuStayTime")))
    y = y + controlHeight + padding
    
    -- 分隔线
    self:addHorizontalLine(y, 1)
    y = y + 20
    
    -- 显示过滤标题
    self:addLabel("显示过滤", 20, y, 1, 0.8, 0.8, 1, UIFont.Small)
    y = y + 25
    
    -- 显示聊天消息
    self.controls.showChatBox = self:addTickBox(20, y, labelWidth, controlHeight, "显示聊天消息", nil)
    self.controls.showChatBox:setSelected(1, DouyinDanmu.getConfig("showChatMessages"))
    y = y + controlHeight
    
    -- 显示礼物消息
    self.controls.showGiftBox = self:addTickBox(20, y, labelWidth, controlHeight, "显示礼物消息", nil)
    self.controls.showGiftBox:setSelected(1, DouyinDanmu.getConfig("showGiftMessages"))
    y = y + controlHeight
    
    -- 显示点赞消息
    self.controls.showLikeBox = self:addTickBox(20, y, labelWidth, controlHeight, "显示点赞消息", nil)
    self.controls.showLikeBox:setSelected(1, DouyinDanmu.getConfig("showLikeMessages"))
    y = y + controlHeight
    
    -- 显示进入直播间消息
    self.controls.showEnterBox = self:addTickBox(20, y, labelWidth, controlHeight, "显示进入直播间消息", nil)
    self.controls.showEnterBox:setSelected(1, DouyinDanmu.getConfig("showEnterMessages"))
    y = y + controlHeight + padding
    
    -- 分隔线
    self:addHorizontalLine(y, 1)
    y = y + 20
    
    -- 按钮
    local buttonWidth = 100
    local buttonHeight = 25
    local buttonPadding = 10
    
    -- 连接按钮
    self.controls.connectButton = ISButton:new(
        self.width / 2 - buttonWidth - buttonPadding, 
        y, 
        buttonWidth, 
        buttonHeight, 
        "连接", 
        self, 
        DouyinDanmu.UI.ConfigWindow.onConnectClick
    )
    self.controls.connectButton:initialise()
    self.controls.connectButton:instantiate()
    self:addChild(self.controls.connectButton)
    
    -- 保存按钮
    self.controls.saveButton = ISButton:new(
        self.width / 2 + buttonPadding, 
        y, 
        buttonWidth, 
        buttonHeight, 
        "保存设置", 
        self, 
        DouyinDanmu.UI.ConfigWindow.onSaveClick
    )
    self.controls.saveButton:initialise()
    self.controls.saveButton:instantiate()
    self:addChild(self.controls.saveButton)
    y = y + buttonHeight + padding
    
    -- 调试模式
    self.controls.debugModeBox = self:addTickBox(20, y, labelWidth, controlHeight, "调试模式", nil)
    self.controls.debugModeBox:setSelected(1, DouyinDanmu.getConfig("debugMode"))
    y = y + controlHeight
    
    -- 关闭按钮
    self.controls.closeButton = ISButton:new(
        self.width - 100 - 10, 
        self.height - 25 - 10, 
        100, 
        25, 
        "关闭", 
        self, 
        DouyinDanmu.UI.ConfigWindow.onCloseClick
    )
    self.controls.closeButton:initialise()
    self.controls.closeButton:instantiate()
    self:addChild(self.controls.closeButton)
end

-- 添加标签
function DouyinDanmu.UI.ConfigWindow:addLabel(text, x, y, r, g, b, a, font)
    local label = ISLabel:new(x, y, 20, text, r, g, b, a, font, true)
    label:initialise()
    label:instantiate()
    self:addChild(label)
    return label
end

-- 添加文本输入框
function DouyinDanmu.UI.ConfigWindow:addTextEntryBox(x, y, width, height)
    local entry = ISTextEntryBox:new("", x, y, width, height)
    entry:initialise()
    entry:instantiate()
    self:addChild(entry)
    return entry
end

-- 添加下拉框
function DouyinDanmu.UI.ConfigWindow:addComboBox(x, y, width, height)
    local combo = ISComboBox:new(x, y, width, height)
    combo:initialise()
    combo:instantiate()
    self:addChild(combo)
    return combo
end

-- 添加复选框
function DouyinDanmu.UI.ConfigWindow:addTickBox(x, y, width, height, text, target)
    local tick = ISTickBox:new(x, y, width, height, text, target)
    tick:initialise()
    tick:instantiate()
    self:addChild(tick)
    return tick
end

-- 添加水平线
function DouyinDanmu.UI.ConfigWindow:addHorizontalLine(y, alpha)
    self:drawRectStatic(20, y, self.width - 40, 1, 1, 1, 1, alpha)
end

-- 连接按钮点击事件
function DouyinDanmu.UI.ConfigWindow:onConnectClick()
    local roomId = self.controls.roomIdEntry:getText()
    if roomId and roomId ~= "" then
        if DouyinDanmu.isConnected then
            DouyinDanmu.disconnectFromLiveRoom()
            self.controls.connectButton:setTitle("连接")
        else
            if DouyinDanmu.connectToLiveRoom(roomId) then
                self.controls.connectButton:setTitle("断开")
            end
        end
    else
        -- 提示用户输入直播间ID
    end
end

-- 保存按钮点击事件
function DouyinDanmu.UI.ConfigWindow:onSaveClick()
    -- 保存直播间ID
    DouyinDanmu.setConfig("roomId", self.controls.roomIdEntry:getText())
    
    -- 保存显示位置
    local positionIndex = self.controls.positionCombo.selected
    if positionIndex == 1 then
        DouyinDanmu.setConfig("displayPosition", "right")
    elseif positionIndex == 2 then
        DouyinDanmu.setConfig("displayPosition", "left")
    elseif positionIndex == 3 then
        DouyinDanmu.setConfig("displayPosition", "top")
    elseif positionIndex == 4 then
        DouyinDanmu.setConfig("displayPosition", "bottom")
    end
    
    -- 保存最大弹幕数
    local maxDanmu = tonumber(self.controls.maxDanmuEntry:getText()) or 20
    DouyinDanmu.setConfig("maxDanmuCount", maxDanmu)
    
    -- 保存弹幕停留时间
    local stayTime = tonumber(self.controls.stayTimeEntry:getText()) or 5
    DouyinDanmu.setConfig("danmuStayTime", stayTime)
    
    -- 保存显示过滤设置
    DouyinDanmu.setConfig("showChatMessages", self.controls.showChatBox:isSelected(1))
    DouyinDanmu.setConfig("showGiftMessages", self.controls.showGiftBox:isSelected(1))
    DouyinDanmu.setConfig("showLikeMessages", self.controls.showLikeBox:isSelected(1))
    DouyinDanmu.setConfig("showEnterMessages", self.controls.showEnterBox:isSelected(1))
    
    -- 保存调试模式设置
    DouyinDanmu.setConfig("debugMode", self.controls.debugModeBox:isSelected(1))
    
    -- 保存配置
    DouyinDanmu.saveConfig()
    
    -- 重新创建UI以应用新设置
    if DouyinDanmu.UI.danmuPanel then
        DouyinDanmu.UI.danmuPanel:removeFromUIManager()
        DouyinDanmu.UI.danmuPanel = nil
    end
    DouyinDanmu.createUI()
end

-- 关闭按钮点击事件
function DouyinDanmu.UI.ConfigWindow:onCloseClick()
    self:setVisible(false)
    self:removeFromUIManager()
    DouyinDanmu.UI.configWindow = nil
end
