-- DouyinDanmu/Main.lua
-- 抖音弹幕Mod主入口文件

require "DouyinDanmu/Config"
require "DouyinDanmu/UI/DanmuPanel"
require "DouyinDanmu/UI/ConfigUI"

-- 全局命名空间
DouyinDanmu = DouyinDanmu or {}
DouyinDanmu.version = "1.0.0"
DouyinDanmu.author = "Manus AI"
DouyinDanmu.isEnabled = true
DouyinDanmu.isConnected = false
DouyinDanmu.danmuQueue = {}
DouyinDanmu.maxDanmuCount = 20 -- 默认最大显示数量

-- 初始化函数
function DouyinDanmu.init()
    print("DouyinDanmu: 初始化模组...")

    -- 加载配置
    DouyinDanmu.loadConfig()

    -- 创建UI
    DouyinDanmu.createUI()

    -- 注册事件
    Events.OnGameStart.Add(DouyinDanmu.onGameStart)
    Events.OnGameBoot.Add(DouyinDanmu.onGameBoot)
    Events.OnGameUpdate.Add(DouyinDanmu.onGameUpdate)
    Events.OnPreUIDraw.Add(DouyinDanmu.onPreUIDraw)

    print("DouyinDanmu: 模组初始化完成")
end

-- 游戏启动时调用
function DouyinDanmu.onGameBoot()
    print("DouyinDanmu: 游戏启动")
end

-- 游戏开始时调用
function DouyinDanmu.onGameStart()
    print("DouyinDanmu: 游戏开始")

    -- 显示配置界面
    if DouyinDanmu.Config.showConfigOnStart then
        DouyinDanmu.UI.showConfigWindow()
    end
end

-- 游戏更新时调用（每帧）
function DouyinDanmu.onGameUpdate()
    -- 处理弹幕队列
    DouyinDanmu.processDanmuQueue()
end

-- 界面绘制前调用
function DouyinDanmu.onPreUIDraw()
    -- 绘制弹幕
    if DouyinDanmu.isEnabled then
        DouyinDanmu.UI.renderDanmu()
    end
end

-- 处理弹幕队列
function DouyinDanmu.processDanmuQueue()
    -- 这里将来会处理从WebSocket接收到的弹幕数据
    -- 目前仅作为占位符
end

-- 添加测试弹幕（仅用于开发测试）
function DouyinDanmu.addTestDanmu()
    local testMessages = {
        {text = "大家好！", user = "用户1", color = {r=1, g=1, b=1}},
        {text = "主播太厉害了！", user = "用户2", color = {r=1, g=0.8, b=0.8}},
        {text = "这游戏好玩吗？", user = "用户3", color = {r=0.8, g=1, b=0.8}},
        {text = "僵尸来了小心！", user = "用户4", color = {r=0.8, g=0.8, b=1}}
    }

    local randomIndex = ZombRand(1, #testMessages + 1)
    local message = testMessages[randomIndex]

    table.insert(DouyinDanmu.danmuQueue, {
        text = message.text,
        user = message.user,
        color = message.color,
        time = getTimestamp()
    })

    -- 限制队列长度
    if #DouyinDanmu.danmuQueue > DouyinDanmu.maxDanmuCount then
        table.remove(DouyinDanmu.danmuQueue, 1)
    end
end

-- 连接到抖音直播间
function DouyinDanmu.connectToLiveRoom(roomId)
    print("DouyinDanmu: 尝试连接到直播间 " .. roomId)
    -- 这里将来会实现与UniBarrage服务的连接
    -- 目前仅作为占位符

    DouyinDanmu.isConnected = true
    DouyinDanmu.Config.roomId = roomId
    DouyinDanmu.saveConfig()

    return true
end

-- 断开与直播间的连接
function DouyinDanmu.disconnectFromLiveRoom()
    print("DouyinDanmu: 断开直播间连接")
    -- 这里将来会实现断开与UniBarrage服务的连接
    -- 目前仅作为占位符

    DouyinDanmu.isConnected = false

    return true
end

-- 初始化模组
DouyinDanmu.init()
