-- 録画の開始と停止をトラッキングするための変数
local is_recording = false

function script_description() -- スクリプトの設定
    return "録画ボタンが押されたときに、録画の開始または停止をログに記録します。"
end

function script_load(settings) -- スクリプトの初期化
    obslua.obs_frontend_add_event_callback(on_event)
end

function on_event(added_event) -- イベントコールバック
    if added_event == obslua.OBS_FRONTEND_EVENT_RECORDING_STARTED then
        is_recording = true
        obslua.script_log(obslua.LOG_INFO, "録画が開始されました。")
    elseif added_event == obslua.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
        is_recording = false
        obslua.script_log(obslua.LOG_INFO, "録画が停止されました。")
    end
end

function script_save(settings) -- スクリプトの設定の保存
end
