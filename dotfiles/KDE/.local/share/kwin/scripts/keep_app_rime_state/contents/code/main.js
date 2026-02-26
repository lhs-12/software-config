/*
 * ============================================================
 *  Fcitx5 Rime Per-App Input State Switcher (KWin Script)
 * ============================================================
 *  起因:
 *  在 KDE 的 Wayland，Fcitx5 配置中, 输入状态分应用设置不生效,
 *  导致不同应用之间共享了输入法状态.
 *
 *  本脚本功能:
 *  通过监听 KWin 的 windowActivated 事件，实现：
 *    不同应用之间的输入状态独立
 *    默认新应用使用 ASCII 模式
 *    切回应用时恢复其上次的 AsciiMode 状态
 *  另外使用 ydotool 模拟先输入Alt再输入Esc, 解决一些Electron应用丢失输入法焦点的问题
 *
 *  注意:
 *  适用于 KDE Wayland + Fcitx5 + Rime, 且设置中的输入法只保留一个 Rime.
 *  切换输入法使用Rime DBus, 而不是fcitx5-remote.
 *  本脚本隔离了不同应用的输入法状态, 而同应用不同窗口的功能则是由Fcitx5自身处理.
 */

var appState = {};
var lastApp = null;
var lastId = null;

// 使用本脚本处理的 Electron 应用
var electronApps = ["code"];

const rimeService = "org.fcitx.Fcitx5";
const rimePath = "/rime";
const rimeInterface = "org.fcitx.Fcitx.Rime1";

const ydotoolService = "com.dbus.ydotool.service";
const ydotoolPath = "/com/dbus/ydotool";
const ydotoolInterface = "com.dbus.ydotool.interface";

// journalctl --user -f | grep kwin_debug
function log(msg) {
  print("[kwin_debug] " + msg);
}

function delay(ms, func) {
  const timer = new QTimer();
  timer.singleShot = true;
  timer.interval = ms;
  timer.timeout.connect(func);
  timer.start();
}

function normalizeBool(result) {
  if (result === true || result === false) return result;
  if (result instanceof Array && result.length > 0) return result[0] === true;
  return false;
}

function isElectronApp(appName) {
  return electronApps.indexOf(appName) !== -1;
}

function queryAsciiModeAndSave(appName) {
  let callback = (r) => (appState[appName] = normalizeBool(r));
  callDBus(rimeService, rimePath, rimeInterface, "IsAsciiMode", callback);
}

function setAsciiMode(state) {
  callDBus(rimeService, rimePath, rimeInterface, "SetAsciiMode", state);
}

function fixElectronIM() {
  // 毫秒延时, 防止前面按键未松开 (低概率触发组合键)
  delay(300, () => {
    // 释放左Ctrl/Shift, 分别按下松开Alt和Esc
    let command = "29:0 42:0 56:1 56:0 1:1 1:0";
    callDBus(ydotoolService, ydotoolPath, ydotoolInterface, "Key", command);
  });
}

workspace.windowActivated.connect(function (client) {
  if (!client || !client.normalWindow) return;
  if (client.internalId === lastId) return;
  lastId = client.internalId;
  var newApp = client.desktopFileName || client.resourceClass;
  if (!newApp || newApp === "kwin_wayland" || newApp === lastApp) return;
  if (lastApp) {
    queryAsciiModeAndSave(lastApp);
  }
  if (appState.hasOwnProperty(newApp)) {
    setAsciiMode(appState[newApp]);
  } else {
    setAsciiMode(true);
  }
  lastApp = newApp;

  if (isElectronApp(newApp)) {
    fixElectronIM(client);
  }
});

workspace.windowRemoved.connect(function (window) {
  if (!window.normalWindow) return;
  let appName = window.desktopFileName || window.resourceClass;
  if (!appName || appName === "kwin_wayland") return;
  let isAppStillActive = workspace.windowList().some(function (w) {
    return w.normalWindow && (w.desktopFileName || w.resourceClass) === appName;
  });
  if (!isAppStillActive) {
    // 延时删, 保证晚于windowActivated的dbus保存旧状态
    delay(100, () => delete appState[appName]);
    if (lastApp === appName) {
      lastApp = null;
      lastId = null;
    }
  }
});
