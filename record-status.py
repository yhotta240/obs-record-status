import obspython as obs

# 録画の開始と停止をトラッキングするための変数
is_recording = False

def script_description(): # スクリプトの説明
    return "録画ボタンが押されたときに、録画の開始または停止をログに記録します。"

def script_load(settings):
    obs.obs_frontend_add_event_callback(on_event)

def on_event(added_event): # イベントコールバック
    global is_recording
    if added_event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED:
        is_recording = True
        obs.script_log(obs.LOG_INFO, "録画が開始されました。")
    elif added_event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED:
        is_recording = False
        obs.script_log(obs.LOG_INFO, "録画が停止されました。")

def script_save(settings): # スクリプトの設定の保存
    pass
