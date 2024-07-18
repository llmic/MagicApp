require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
local MediaPlayer = luajava.bindClass "android.media.MediaPlayer"
local Uri = luajava.bindClass "android.net.Uri"
local Intent = luajava.bindClass "android.content.Intent"
import "android.media.AudioManager"
      local Context = luajava.bindClass "android.content.Context"
      mAudioManager=activity.getSystemService(Context.AUDIO_SERVICE);
      mVolume=mAudioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
   
list=activity.getLuaDir()
applistt={}
local packageMgr = activity.getPackageManager()
local packages = packageMgr.getInstalledPackages(0)
for count = 0, #packages - 1 do
  local packageInfo = packages[count]
  local appInfo = packageInfo.applicationInfo
  local h = (appInfo.loadLabel(packageMgr))
  table.insert(applistt,h)
end
function randomStart()

  rM=math.random(0,8)
  if ifhas[rM] and rM <=4 then
    EasyJump(checklist[rM])
   elseif rM == 5 and ifhas[rM]then Normaljump("com.netease.cloudmusic","https://music.163.com/m/song?id=2090390659")
   elseif rM==8 then Normaljump("tv.danmaku.bili","https://b23.tv/Lf5Bpzv")
   elseif rM==7 then Normaljump("tv.danmaku.bili","https://b23.tv/HmBVIy0")
   elseif rM == 6 and ifhas[5]then Normaljump("com.netease.cloudmusic","https://music.163.com/m/song?id=2155423468")
   else
    task(1,function() randomStart() end)
  end
end
function start()
  mPlayer = MediaPlayer()
  mPlayer.reset()
  mPlayer.setDataSource(tostring(list).."/genshin_start.mp3")
  mPlayer.prepareAsync()
  mPlayer.setLooping(false)
  mPlayer.setOnPreparedListener(MediaPlayer.OnPreparedListener{
    onPrepared=function(mmp)
      mAudioManager.setStreamVolume(AudioManager.STREAM_MUSIC,100,0);
      mPlayer.seekTo(63000)
      mPlayer.start()
      ti=Ticker()
      ti.Period=1000
      ti.onTick=function()
        if mPlayer.getCurrentPosition() >= 80000 then
          ti.stop()
          randomStart()
        end
      end
      ti.start()
    end});
end
function EasyJump(appname)
  for jdpuk in each(this.packageManager.getInstalledApplications(0))do
    if appname==this.packageManager.getApplicationLabel(jdpuk)then
      this.startActivity(this.packageManager.getLaunchIntentForPackage(jdpuk.packageName))
      return
    end
  end
end
function Normaljump(QPackageName,uri)
  local intent=Intent("android.intent.action.VIEW")
  intent.setPackage(QPackageName)
  intent.setData(Uri.parse(uri))
  intent.addFlags(intent.FLAG_ACTIVITY_NEW_TASK)
  activity.startActivity(intent)
end
function Check(appname)
  a=false
  for r,e in ipairs(applistt)
    if e==appname then
      a = true end
  end
  return a
end
function second()
  start()
end
function NormalPlay(u,t)
  mmPlayer = MediaPlayer()
  mmPlayer.reset()
  mmPlayer.setDataSource(tostring(list).."/"..u)
  mmPlayer.prepareAsync()
  mmPlayer.setLooping(false)
  mmPlayer.setOnPreparedListener(MediaPlayer.OnPreparedListener{
    onPrepared=function(mmp)
      mmPlayer.start()
    end})
  if t == true then
    mmPlayer.setOnCompletionListener(MediaPlayer.OnCompletionListener{
      onCompletion=function(v)
        audioNext(ifhas)
      end
    });
  end
end
k=0
audiolist={"yuanshen.mp3","mrfz.mp3","bilanyaozi.mp3","ba.mp3","netease_music.mp3"}
function audioNext(tablee)
  task(1,function()
    k=k+1
    if k <=5 and k !=0 then
      if tostring(tablee[k]) == "true" then NormalPlay(audiolist[k],true) else audioNext(ifhas) end
    end
    if k == 6 then NormalPlay("final_conclusion.mp3",true)
    end
    if k == 7 then NormalPlay("sec_main.mp3",true)
         mAudioManager.setStreamVolume(AudioManager.STREAM_MUSIC,80,0);
    end
    if k == 8 then
      second()
    end
  end)
end
checklist={"原神","明日方舟","碧蓝航线","蔚蓝档案","网易云音乐"}
ifhas={}
for r,e in ipairs(checklist) do
  if Check(e) then
    table.insert(ifhas,true) else table.insert(ifhas,false) end
end
function main()
  NormalPlay("Letmesee.mp3")
  mmPlayer.setOnCompletionListener(MediaPlayer.OnCompletionListener{
    onCompletion=function(v)
      task(1,function()
        audioNext(ifhas)
      end)
    end})
end
layout={LinearLayout,layout_width="match",layout_height="match",gravity="center",Orientation=1,
  {TextView,text="请同意一下权限",},
  {LinearLayout,layout_width="wrap",layout_height="wrap",gravity="center",layout_margin="10dp",
    {CircleImageView,layout_height="match",src="HeadImg.jpg",},
    {TextView,text="  清汀琉璃",textColor="#FF1B92F3"},}}
activity.setContentView(loadlayout(layout))
task(1,function()
  main()
end)