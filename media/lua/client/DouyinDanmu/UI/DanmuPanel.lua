-- DouyinDanmu/UI/DanmuPanel.lua
-- 抖音弹幕显示面板

require "ISUI/ISPanel"

DouyinDanmu = DouyinDanmu or {}
DouyinDanmu.UI = DouyinDanmu.UI or {}

-- 弹幕面板类，继承自ISPanel
DouyinDanmu.UI.DanmuPanel = ISPanel:derive("DouyinDanmu.UI.DanmuPanel")

-- 创建UI
function DouyinDanmu.createUI()
    -- 获取屏幕尺寸
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    
    -- 根据配置确定弹幕面板位置和大小
    local panelWidth = 300
    local panelHeight = 400
    local panelX, panelY = 0, 0
    
    local position = DouyinDanmu.getConfig("displayPosition")
    if position == "right" then
        panelX = screenWidth - panelWidth - 20
        panelY = 100
    elseif position == "left" then
        panelX = 20
        panelY = 100
    elseif position == "top" then
        panelX = (screenWidth - panelWidth) / 2
        panelY = 20
    elseif position == "bottom" then
        panelX = (screenWidth - panelWidth) / 2
        panelY = screenHeight - panelHeight - 20
    end
    
    -- 创建弹幕面板
    DouyinDanmu.UI.danmuPanel = DouyinDanmu.UI.DanmuPanel:new(
        panelX, panelY, panelWidth, panelHeight
    )
    DouyinDanmu.UI.danmuPanel:initialise()
    DouyinDanmu.UI.danmuPanel:instantiate()
    DouyinDanmu.UI.danmuPanel:setVisible(true)
    DouyinDanmu.UI.danmuPanel:addToUIManager()
    
    print("DouyinDanmu: UI创建完成")
end

-- 构造函数
function DouyinDanmu.UI.DanmuPanel:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    
    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.backgroundColor = {r=0, g=0, b=0, a=0} -- 透明背景
    o.borderColor = {r=0, g=0, b=0, a=0}     -- 透明边框
    o.moveWithMouse = false
    o.danmuItems = {}
    
    return o
end

-- 初始化
function DouyinDanmu.UI.DanmuPanel:initialise()
    ISPanel.initialise(self)
end

-- 预渲染
function DouyinDanmu.UI.DanmuPanel:prerender()
    -- 不需要绘制背景和边框
end

-- 渲染
function DouyinDanmu.UI.DanmuPanel:render()
    -- 渲染弹幕
    self:renderDanmuItems()
end

-- 渲染弹幕项目
function DouyinDanmu.UI.DanmuPanel:renderDanmuItems()
    local y = 0
    local lineHeight = 20
    local opacity = DouyinDanmu.getConfig("opacity")
    
    -- 根据字体大小设置
    local fontSize = DouyinDanmu.getConfig("fontSize")
    if fontSize == "small" then
        lineHeight = 16
    elseif fontSize == "medium" then
        lineHeight = 20
    elseif fontSize == "large" then
        lineHeight = 24
    end
    
    -- 渲染每条弹幕
    for i, danmu in ipairs(DouyinDanmu.danmuQueue) do
        -- 计算弹幕位置
        local danmuY = y + (i-1) * lineHeight
        
        -- 设置颜色
        local r, g, b = danmu.color.r, danmu.color.g, danmu.color.b
        self:drawText(danmu.user .. ": " .. danmu.text, 10, danmuY, r, g, b, opacity)
    end
end

-- 渲染弹幕（供外部调用）
function DouyinDanmu.UI.renderDanmu()
    -- 这个函数会在onPreUIDraw事件中被调用
    -- 目前弹幕面板已经在UI管理器中，会自动渲染
    
    -- 添加测试弹幕（仅用于开发测试）
    if DouyinDanmu.getConfig("debugMode") and ZombRand(100) < 2 then
        DouyinDanmu.addTestDanmu()
    end
end
