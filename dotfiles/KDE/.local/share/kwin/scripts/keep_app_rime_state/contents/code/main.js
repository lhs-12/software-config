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
 *
 *  注意:
 *  适用于 KDE Wayland + Fcitx5 + Rime, 且设置中的输入法只保留一个 Rime.
 *  切换输入法使用Rime DBus, 而不是fcitx5-remote.
 *  本脚本隔离了不同应用的输入法状态, 而同应用不同窗口的功能则是由Fcitx5自身处理.
 */

var appState = {};
var lastApp = null;
var lastId = null;

var rimeService = "org.fcitx.Fcitx5";
var rimePath = "/rime";
var rimeInterface = "org.fcitx.Fcitx.Rime1";

function normalizeBool(result) {
  if (result === true || result === false) return result;
  if (result instanceof Array && result.length > 0) return result[0] === true;
  return false;
}

function queryAsciiModeAndSave(appName) {
  callDBus(
    rimeService,
    rimePath,
    rimeInterface,
    "IsAsciiMode",
    function (result) {
      appState[appName] = normalizeBool(result);
    },
  );
}

function setAsciiMode(state) {
  callDBus(rimeService, rimePath, rimeInterface, "SetAsciiMode", state);
}

workspace.windowActivated.connect(function (client) {
  if (!client) return;
  if (client.internalId === lastId) return;

  lastId = client.internalId;

  var newApp = client.desktopFileName || client.resourceClass;
  if (!newApp) return;
  if (newApp === lastApp) return;
  if (lastApp) {
    queryAsciiModeAndSave(lastApp);
  }
  if (appState.hasOwnProperty(newApp)) {
    setAsciiMode(appState[newApp]);
  } else {
    setAsciiMode(true);
  }
  lastApp = newApp;
});
