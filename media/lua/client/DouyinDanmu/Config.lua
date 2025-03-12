-- DouyinDanmu/Config.lua
-- 抖音弹幕Mod配置文件

DouyinDanmu = DouyinDanmu or {}
DouyinDanmu.Config = DouyinDanmu.Config or {}

-- 默认配置
DouyinDanmu.Config.default = {
    -- 基本设置
    roomId = "",                  -- 抖音直播间ID
    displayPosition = "right",    -- 弹幕显示位置 (top, bottom, left, right)
    maxDanmuCount = 20,           -- 弹幕显示数量上限
    danmuStayTime = 5,            -- 弹幕停留时间(秒)

    -- 显示过滤
    showChatMessages = true,      -- 显示普通聊天消息
    showGiftMessages = true,      -- 显示礼物消息
    showLikeMessages = true,      -- 显示点赞消息
    showEnterMessages = false,    -- 显示进入直播间消息

    -- 外观设置
    fontSize = "medium",          -- 弹幕字体大小 (small, medium, large)
    textColor = {r=1, g=1, b=1},  -- 弹幕默认颜色
    opacity = 0.8,                -- 弹幕透明度
    animation = "scroll",         -- 弹幕动画效果 (scroll, fade, none)

    -- 高级设置
    uniBarrageServer = "http://localhost:8080",  -- UniBarrage服务器地址
    connectionTimeout = 30,       -- 连接超时设置(秒)
    reconnectAttempts = 3,        -- 重连尝试次数
    debugMode = false,            -- 调试模式开关
    showConfigOnStart = true      -- 游戏开始时显示配置界面
}

-- 当前配置
DouyinDanmu.Config.current = {}

-- 加载配置
function DouyinDanmu.loadConfig()
    print("DouyinDanmu: 加载配置...")

    -- 复制默认配置到当前配置
    for k, v in pairs(DouyinDanmu.Config.default) do
        DouyinDanmu.Config.current[k] = v
    end

    -- 从保存的配置文件加载
    local savedConfig = ModData.getOrCreate("DouyinDanmu")
    if savedConfig then
        for k, v in pairs(savedConfig) do
            DouyinDanmu.Config.current[k] = v
        end
    end

    -- 更新全局设置
    DouyinDanmu.maxDanmuCount = DouyinDanmu.Config.current.maxDanmuCount

    print("DouyinDanmu: 配置加载完成")
end

-- 保存配置
function DouyinDanmu.saveConfig()
    print("DouyinDanmu: 保存配置...")

    -- 保存到ModData
    ModData.add("DouyinDanmu", DouyinDanmu.Config.current)

    print("DouyinDanmu: 配置保存完成")
end

-- 重置配置为默认值
function DouyinDanmu.resetConfig()
    print("DouyinDanmu: 重置配置...")

    -- 复制默认配置到当前配置
    for k, v in pairs(DouyinDanmu.Config.default) do
        DouyinDanmu.Config.current[k] = v
    end

    -- 保存配置
    DouyinDanmu.saveConfig()

    -- 更新全局设置
    DouyinDanmu.maxDanmuCount = DouyinDanmu.Config.current.maxDanmuCount

    print("DouyinDanmu: 配置重置完成")
end

-- 获取配置值
function DouyinDanmu.getConfig(key)
    return DouyinDanmu.Config.current[key]
end

-- 设置配置值
function DouyinDanmu.setConfig(key, value)
    DouyinDanmu.Config.current[key] = value

    -- 更新相关全局设置
    if key == "maxDanmuCount" then
        DouyinDanmu.maxDanmuCount = value
    end
end
