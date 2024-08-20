package com.example.root_detection

import android.content.Context
import androidx.annotation.NonNull
import com.scottyab.rootbeer.RootBeer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.BufferedReader
import java.io.File
import java.io.IOException
import java.io.InputStreamReader

class RootDetectionPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "root_detection")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "isDeviceRooted") {
            val isRooted = isDeviceRooted()
            result.success(isRooted)
        } else {
            result.notImplemented()
        }
    }

    private fun isDeviceRooted(): Boolean {
        return checkForSU() || checkForRootManagementApps() || checkForDangerousProps() ||
                checkForRWPaths() || checkForBusyBoxBinary() || executeCommands() || checkForRootCloakingApps()
    }

    private fun checkForSU(): Boolean {
        val paths = arrayOf("/system/xbin/su", "/system/bin/su")
        for (path in paths) {
            val file = File(path)
            if (file.exists() && canExecuteSU()) return true
        }
        return false
    }

    private fun canExecuteSU(): Boolean {
        var process: Process? = null
        return try {
            process = Runtime.getRuntime().exec(arrayOf("which", "su"))
            val input = BufferedReader(InputStreamReader(process.inputStream))
            input.readLine() != null
        } catch (t: Throwable) {
            false
        } finally {
            process?.destroy()
        }
    }

    private fun checkForRootManagementApps(): Boolean {
        val packages = arrayOf(
            "com.noshufou.android.su", "eu.chainfire.supersu", "com.koushikdutta.superuser",
            "com.thirdparty.superuser", "com.yellowes.su", "com.topjohnwu.magisk"
        )
        for (packageName in packages) {
            if (isPackageInstalled(packageName)) return true
        }
        return false
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        val pm = context?.packageManager ?: return false
        return try {
            pm.getPackageInfo(packageName, 0)
            true
        } catch (e: Exception) {
            false
        }
    }

    private fun checkForDangerousProps(): Boolean {
        val lines = arrayOf("ro.debuggable=1", "ro.secure=0")
        for (line in lines) {
            val keyValue = line.split("=")
            val property = getSystemProperty(keyValue[0])
            if (property == keyValue[1]) return true
        }
        return false
    }

    private fun getSystemProperty(propName: String): String? {
        var line: String? = null
        var input: BufferedReader? = null
        try {
            val p = Runtime.getRuntime().exec("getprop $propName")
            input = BufferedReader(InputStreamReader(p.inputStream), 1024)
            line = input.readLine()
            input.close()
        } catch (ex: IOException) {
            return null
        } finally {
            input?.close()
        }
        return line
    }

    private fun checkForRWPaths(): Boolean {
        val paths = arrayOf("/system", "/system/bin", "/system/sbin", "/system/xbin", "/vendor/bin", "/sbin", "/etc")
        for (path in paths) {
            val dir = File(path)
            if (dir.exists() && dir.canWrite()) return true
        }
        return false
    }

    private fun checkForBusyBoxBinary(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("which", "busybox"))
            val input = BufferedReader(InputStreamReader(process.inputStream))
            input.readLine() != null
        } catch (t: Throwable) {
            false
        }
    }

    private fun executeCommands(): Boolean {
        val commands = arrayOf("/system/xbin/which su", "/system/bin/which su", "which su")
        for (command in commands) {
            try {
                val process = Runtime.getRuntime().exec(command)
                val input = BufferedReader(InputStreamReader(process.inputStream))
                if (input.readLine() != null) return true
            } catch (t: Throwable) {
                // Ignored
            }
        }
        return false
    }

    private fun checkForRootCloakingApps(): Boolean {
        val packages = arrayOf(
            "com.devadvance.rootcloak", "de.robv.android.xposed.installer", "com.saurik.substrate",
            "com.zachspong.temprootremovejb", "com.amphoras.hidemyroot", "com.formyhm.hideroot"
        )
        for (packageName in packages) {
            if (isPackageInstalled(packageName)) return true
        }
        return false
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        context = binding.activity.applicationContext
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        context = binding.activity.applicationContext
    }

    override fun onDetachedFromActivity() {}
}