import Flutter
import UIKit

public class RootDetectionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "root_detection", binaryMessenger: registrar.messenger())
    let instance = RootDetectionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "isDeviceRooted" {
      result(isJailbroken())
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func isJailbroken() -> Bool {
    #if targetEnvironment(simulator)
    return false
    #else
    if JailbreakDetection.isJailbroken() {
      return true
    }
    return false
    #endif
  }
}

public class JailbreakDetection {
  static func isJailbroken() -> Bool {
    if hasCydiaInstalled() || hasSuspiciousApps() || hasSuspiciousPaths() || canEditSystemFiles() {
      return true
    }
    return false
  }

  static func hasCydiaInstalled() -> Bool {
    return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
  }

  static func hasSuspiciousApps() -> Bool {
    let suspiciousApps = [
      "com.apple.cydia",
      "org.coolstar.sileo",
      "com.saurik.iphone.terminal"
    ]
    for app in suspiciousApps {
      if UIApplication.shared.canOpenURL(URL(string: "\(app)://")!) {
        return true
      }
    }
    return false
  }

  static func hasSuspiciousPaths() -> Bool {
    let paths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt"
    ]
    for path in paths {
      if FileManager.default.fileExists(atPath: path) {
        return true
      }
    }
    return false
  }

  static func canEditSystemFiles() -> Bool {
    let testString = "Jailbreak test."
    do {
      try testString.write(toFile: "/private/test_jb.txt", atomically: true, encoding: String.Encoding.utf8)
      try FileManager.default.removeItem(atPath: "/private/test_jb.txt")
      return true
    } catch {
      return false
    }
  }
}
