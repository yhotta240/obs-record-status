## はじめに
OBS Studioは，ライブストリーミングや画面録画を行うための人気のあるオープンソースソフトウェアです。OBSでは，配信や録画に関連する多くの機能をカスタマイズできますが，APIを利用することでさらに高度な自動化や制御を実現できます。

この記事では，録画ボタンが押されたときにメッセージを表示し，録画の開始・停止を記録する簡単なスクリプトの作り方を紹介します。

## OBS Studioのスクリプトとは？
OBS Studioは，LuaとPythonのスクリプトを使って様々なカスタマイズができるプラットフォームです。スクリプトを用いることで配信の自動化や複雑な設定を一括で管理することができ，配信者や技術者の負担を減らすことが可能です。

例えば，OBSのAPIを使えば次のようなことができます。

- 録画や配信の自動スタート・ストップ
- イベント発生時に特定の動作を実行
- 配信や録画状態をチェックして通知を出す
- 他のアプリケーションと連携

## LuaとPythonの違い
OBSではLuaとPythonの2つのスクリプト言語がサポートされています。以下はそれぞれの特徴です。

- **Lua** : 軽量でシンプルなスクリプト言語。OBSに組み込まれており，LuaスクリプトはOBS内で直接実行できます。軽快に動作するため，手軽にカスタマイズを行いたい場合に向いています。

- **Python** : より汎用的で，OBSの外部ライブラリとの連携や複雑な処理を行いたい場合に便利です。Pythonを使う場合，OBSにはPythonインタープリタ（バージョン3.6）が必要です。

どちらもOBSのAPIを利用して同じような操作ができますが，使用する言語は好みに応じて選ぶことができます。

## 録画イベントをログに記録するスクリプト
今回は例として，録画ボタンが押された際にログにメッセージを表示するスクリプトを作成してみましょう。最初にPythonを使った例を紹介し，後ほどLua版も紹介します。

### Pythonスクリプトの例
以下は，OBSの録画が開始・停止されたときにメッセージをログに記録する簡単なPythonスクリプトです。

```py:record-status.py
import obspython as obs

# 録画の開始と停止をトラッキングするための変数
is_recording = False

def script_description(): # スクリプトの説明
    return "録画ボタンが押されたときに，録画の開始または停止をログに記録します。"

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

```


### Luaスクリプトの例
同じ機能をLuaで実装した場合のスクリプトも以下に示します。
```lua:record-status.lue
-- 録画の開始と停止をトラッキングするための変数
local is_recording = false

function script_description() -- スクリプトの設定
    return "録画ボタンが押されたときに，録画の開始または停止をログに記録します。"
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

```

作成したファイルは，
`C:\Program Files\obs-studio\data\obs-plugins\frontend-tools\scripts`
にコピーまたは移動しておきましょう。

## スクリプトの導入方法
OBSでスクリプトを実行するためには，以下の手順を行います。

#### 1. OBS Studioを開く
OBSを起動し，上部メニューの「ツール」>「スクリプト」を選択します。

![スクリーンショット 2024-10-13 220831.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3680988/06826eea-4b9f-9aaf-ac93-5b9373000b2e.png)

#### 2. スクリプトを追加
「スクリプト」ウィンドウが開いたら，「+」ボタンをクリックします。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3680988/2b2cbfc2-590c-3acb-85ad-765c0fd8c04a.png)

作成したPythonまたはLuaのスクリプトファイルを選択します。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3680988/ee4f67e5-1980-a0e8-7a7c-9ad37a0f6123.png)

#### 3. 確認
スクリプトログを開きます

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3680988/a6d3397c-69a2-d792-0213-cc9487b1421f.png)

録画ボタンを押すと，スクリプトがトリガーされ，OBSのスクリプトログに「録画が開始されました」または「録画が停止されました」と表示されるはずです。

![スクリーンショット 2024-10-13 223037.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3680988/35d97fde-5721-9ee1-86b6-8d7cfd59820e.png)


## 実践的なカスタマイズ例
この基本的なスクリプトをさらに拡張して，実際の配信や録画で役立つ機能を追加することも可能です。

- **通知機能**: 録画が開始または停止されたときにデスクトップ通知を表示する
- **自動化**: 録画が開始されたら，他の特定の設定（例：特定のシーンへの切り替え）を自動で行う
- **ファイル管理**: 録画が終了すると，自動でファイル名を変更して整理する


## まとめ
OBS StudioのAPIを利用することで，シンプルなスクリプトで録画や配信を管理したり，自動化したりすることができます。今回紹介したPythonやLuaのスクリプトを使って，録画ボタンの操作をログに記録するだけでなく様々なカスタマイズが可能です。

また，今回のスクリプトは録画に限ったものでしたが，配信が開始された際にDiscordやLINEなどに即座に通知を送ったり，API等を使ってX（旧Twitter）などに自動で告知を行うといった用途にも活用できます。こうした機能は，配信者やVTuberなどの方々にとって非常に役立つはずです。

自分の配信や録画に合わせた自動化を取り入れることで，OBSの操作をより効率的に、そしてクリエイティブにすることができるでしょう。

## 参考

https://qiita.com/natmark/items/66bf793253aa2d4b151d

▼ Python/Lua スクリプト

https://docs.obsproject.com/scripting

▼ イベントが発生したときに呼び出されるコールバック関数

https://docs.obsproject.com/reference-frontend-api#c.obs_frontend_add_event_callback
