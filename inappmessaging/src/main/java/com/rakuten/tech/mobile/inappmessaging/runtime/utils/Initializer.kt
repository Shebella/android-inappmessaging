package com.rakuten.tech.mobile.inappmessaging.runtime.utils

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager.NameNotFoundException
import android.os.Build
import android.provider.Settings
import androidx.core.content.pm.PackageInfoCompat
import com.facebook.drawee.backends.pipeline.Fresco
import com.google.gson.Gson
import com.rakuten.tech.mobile.inappmessaging.runtime.data.models.HostAppInfo
import com.rakuten.tech.mobile.inappmessaging.runtime.data.repositories.HostAppInfoRepository
import com.rakuten.tech.mobile.inappmessaging.runtime.exception.InAppMessagingInitializationException
import timber.log.Timber
import java.util.Locale

/**
 * IAM SDK initialization class.
 */
internal object Initializer {

    private const val TAG = "IAM_InitWorker"

    /**
     * This method returns a string of Android Device ID. Note: In order to get device ID without Context,
     * use HostAppInfoRepo.
     */
    @SuppressLint("HardwareIds") // Suppress lint check of using device id.
    private fun getDeviceId(context: Context): String =
            Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)

    /**
     * This method gets device's locale based on API level.
     */
    @Suppress("DEPRECATION")
    @TargetApi(Build.VERSION_CODES.N)
    private fun getLocale(context: Context): Locale? =
            if (BuildVersionChecker.instance().isNougatAndAbove()) {
                context.resources.configuration.locales[0]
            } else {
                context.resources.configuration.locale
            }

    /**
     * This method retrieves host app's app version.
     */
    @TargetApi(Build.VERSION_CODES.P)
    private fun getHostAppVersion(context: Context): String {
        val hostPackageName = getHostAppPackageName(context)
        var packageInfo: PackageInfo? = null
        try {
            packageInfo = context.packageManager.getPackageInfo(hostPackageName, 0)
        } catch (e: NameNotFoundException) {
            Timber.tag(TAG).d(e)
        }
        if (packageInfo == null) {
            return ""
        }
        val versionCode = PackageInfoCompat.getLongVersionCode(packageInfo)
        return packageInfo.versionName + "." + versionCode
    }

    /**
     * This method retrieves host app's package name.
     */
    private fun getHostAppPackageName(context: Context): String =
            if (context.packageName != null) context.packageName else ""

    /**
     * This method returns the result of the background work. Work is consist of retrieve and
     * store host app information, then schedule a request to sync with config service.
     */
    @Suppress("LongMethod")
    @Throws(InAppMessagingInitializationException::class)
    fun initializeSdk(context: Context, subscriptionKey: String?, configUrl: String?, isForTesting: Boolean = false) {

        val hostAppInfo = HostAppInfo(
                getHostAppPackageName(context),
                getDeviceId(context),
                getHostAppVersion(context),
                subscriptionKey,
                getLocale(context),
                configUrl)

        // Store hostAppInfo in repository.
        HostAppInfoRepository.instance().addHostInfo(hostAppInfo)

        // Initialize Fresco library if it's not initialized already.
        if (!Fresco.hasBeenInitialized() && !isForTesting) {
            Fresco.initialize(context)
        }
        Timber.tag(TAG).d(Gson().toJson(hostAppInfo))
    }
}
