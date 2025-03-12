-- DouyinDanmu/DanmuService.lua
-- 抖音弹幕获取服务

require "DouyinDanmu/Utils/WebSocket"
require "DouyinDanmu/Utils/JSON"

DouyinDanmu = DouyinDanmu or {}
DouyinDanmu.DanmuService = DouyinDanmu.DanmuService or {}

-- 初始化弹幕服务
function DouyinDanmu.DanmuService.init()
    print("DouyinDanmu.DanmuService: 初始化弹幕服务")

    -- 初始化状态
    DouyinDanmu.DanmuService.isRunning = false
    DouyinDanmu.DanmuService.lastUpdateTime = 0
    DouyinDanmu.DanmuService.updateInterval = 500 -- 更新间隔（毫秒）

    -- 注册更新事件
    Events.OnGameUpdate.Add(DouyinDanmu.DanmuService.update)

    print("DouyinDanmu.DanmuService: 初始化完成")
end

-- 启动弹幕服务
function DouyinDanmu.DanmuService.start(roomId)
    print("DouyinDanmu.DanmuService: 启动弹幕服务，直播间ID: " .. roomId)

    -- 连接到抖音直播间
    local success = DouyinDanmu.WebSocket.connect(roomId)

    if success then
        DouyinDanmu.DanmuService.isRunning = true
        return true
    else
        return false
    end
end

-- 停止弹幕服务
function DouyinDanmu.DanmuService.stop()
    print("DouyinDanmu.DanmuService: 停止弹幕服务")

    -- 断开连接
    DouyinDanmu.WebSocket.disconnect()

    DouyinDanmu.DanmuService.isRunning = false
    return true
end

-- 更新弹幕服务（每帧调用）
function DouyinDanmu.DanmuService.update()
    -- 如果服务未运行，直接返回
    if not DouyinDanmu.DanmuService.isRunning then
        return
    end

    -- 限制更新频率
    local currentTime = getTimestampMs()
    if currentTime - DouyinDanmu.DanmuService.lastUpdateTime < DouyinDanmu.DanmuService.updateInterval then
        return
    end

    DouyinDanmu.DanmuService.lastUpdateTime = currentTime

    -- 检查WebSocket状态
    local status = DouyinDanmu.WebSocket.checkStatus()

    -- 根据状态更新UI
    if status == DouyinDanmu.WebSocket.STATUS.CONNECTED then
        -- 已连接状态，WebSocket.checkStatus会自动获取弹幕数据
        DouyinDanmu.isConnected = true
    elseif status == DouyinDanmu.WebSocket.STATUS.DISCONNECTED then
        -- 断开连接状态
        DouyinDanmu.isConnected = false
        DouyinDanmu.DanmuService.isRunning = false
    elseif status == DouyinDanmu.WebSocket.STATUS.ERROR then
        -- 错误状态
        DouyinDanmu.isConnected = false
        DouyinDanmu.DanmuService.isRunning = false
        print("DouyinDanmu.DanmuService: 连接错误")
    end
end

-- 初始化
DouyinDanmu.DanmuService.init()
