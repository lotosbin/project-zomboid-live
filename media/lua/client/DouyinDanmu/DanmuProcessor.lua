-- DouyinDanmu/DanmuProcessor.lua
-- 抖音弹幕处理模块

DouyinDanmu = DouyinDanmu or {}
DouyinDanmu.DanmuProcessor = DouyinDanmu.DanmuProcessor or {}

-- 初始化弹幕处理器
function DouyinDanmu.DanmuProcessor.init()
    print("DouyinDanmu.DanmuProcessor: 初始化弹幕处理器")
    
    -- 初始化消息类型过滤器
    DouyinDanmu.DanmuProcessor.filters = {
        chat = DouyinDanmu.getConfig("showChatMessages"),
        gift = DouyinDanmu.getConfig("showGiftMessages"),
        like = DouyinDanmu.getConfig("showLikeMessages"),
        enter = DouyinDanmu.getConfig("showEnterMessages")
    }
    
    print("DouyinDanmu.DanmuProcessor: 初始化完成")
end

-- 处理弹幕消息
function DouyinDanmu.processDanmuMessage(message)
    -- 检查消息类型
    local messageType = message.type or "chat"
    
    -- 根据过滤器决定是否显示
    if not DouyinDanmu.DanmuProcessor.filters[messageType] then
        return
    end
    
    -- 根据消息类型处理
    if messageType == "chat" then
        DouyinDanmu.DanmuProcessor.processChatMessage(message)
    elseif messageType == "gift" then
        DouyinDanmu.DanmuProcessor.processGiftMessage(message)
    elseif messageType == "like" then
        DouyinDanmu.DanmuProcessor.processLikeMessage(message)
    elseif messageType == "enter" then
        DouyinDanmu.DanmuProcessor.processEnterMessage(message)
    end
end

-- 处理聊天消息
function DouyinDanmu.DanmuProcessor.processChatMessage(message)
    -- 创建弹幕对象
    local danmu = {
        text = message.content,
        user = message.username,
        color = {r=1, g=1, b=1}, -- 默认白色
        time = getTimestamp(),
        type = "chat"
    }
    
    -- 添加到弹幕队列
    table.insert(DouyinDanmu.danmuQueue, danmu)
    
    -- 限制队列长度
    if #DouyinDanmu.danmuQueue > DouyinDanmu.maxDanmuCount then
        table.remove(DouyinDanmu.danmuQueue, 1)
    end
end

-- 处理礼物消息
function DouyinDanmu.DanmuProcessor.processGiftMessage(message)
    -- 创建弹幕对象
    local danmu = {
        text = "送出了 " .. (message.giftName or "礼物") .. " x" .. (message.giftCount or 1),
        user = message.username,
        color = {r=1, g=0.5, b=0.5}, -- 粉红色
        time = getTimestamp(),
        type = "gift"
    }
    
    -- 添加到弹幕队列
    table.insert(DouyinDanmu.danmuQueue, danmu)
    
    -- 限制队列长度
    if #DouyinDanmu.danmuQueue > DouyinDanmu.maxDanmuCount then
        table.remove(DouyinDanmu.danmuQueue, 1)
    end
end

-- 处理点赞消息
function DouyinDanmu.DanmuProcessor.processLikeMessage(message)
    -- 创建弹幕对象
    local danmu = {
        text = "点了赞",
        user = message.username,
        color = {r=0.5, g=0.5, b=1}, -- 蓝色
        time = getTimestamp(),
        type = "like"
    }
    
    -- 添加到弹幕队列
    table.insert(DouyinDanmu.danmuQueue, danmu)
    
    -- 限制队列长度
    if #DouyinDanmu.danmuQueue > DouyinDanmu.maxDanmuCount then
        table.remove(DouyinDanmu.danmuQueue, 1)
    end
end

-- 处理进入直播间消息
function DouyinDanmu.DanmuProcessor.processEnterMessage(message)
    -- 创建弹幕对象
    local danmu = {
        text = "进入了直播间",
        user = message.username,
        color = {r=0.5, g=1, b=0.5}, -- 绿色
        time = getTimestamp(),
        type = "enter"
    }
    
    -- 添加到弹幕队列
    table.insert(DouyinDanmu.danmuQueue, danmu)
    
    -- 限制队列长度
    if #DouyinDanmu.danmuQueue > DouyinDanmu.maxDanmuCount then
        table.remove(DouyinDanmu.danmuQueue, 1)
    end
end

-- 更新过滤器
function DouyinDanmu.DanmuProcessor.updateFilters()
    DouyinDanmu.DanmuProcessor.filters = {
        chat = DouyinDanmu.getConfig("showChatMessages"),
        gift = DouyinDanmu.getConfig("showGiftMessages"),
        like = DouyinDanmu.getConfig("showLikeMessages"),
        enter = DouyinDanmu.getConfig("showEnterMessages")
    }
end

-- 初始化
DouyinDanmu.DanmuProcessor.init()
