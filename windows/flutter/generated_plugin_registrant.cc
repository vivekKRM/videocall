//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <agora_rtc_engine/agora_rtc_engine_plugin.h>
#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <firebase_core/firebase_core_plugin_c_api.h>
#include <iris_method_channel/iris_method_channel_plugin_c_api.h>
#include <local_auth_windows/local_auth_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AgoraRtcEnginePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AgoraRtcEnginePlugin"));
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  IrisMethodChannelPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("IrisMethodChannelPluginCApi"));
  LocalAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalAuthPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
