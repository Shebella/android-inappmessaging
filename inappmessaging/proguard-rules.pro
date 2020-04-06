# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Ignore annotation used for build tooling.
#-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
#-dontwarn java.lang.invoke.LambdaMetafactory

###################
#                 #
#  Project rules  #
#                 #
###################

-keep class com.rakuten.tech.mobile.inappmessaging.runtime.data.requests.ConfigRequest { *; }
-keep class com.rakuten.tech.mobile.inappmessaging.runtime.data.requests.PingRequest { *; }
-keep class com.rakuten.tech.mobile.inappmessaging.runtime.data.requests.DisplayPermissionRequest { *; }
-keep class com.rakuten.tech.mobile.inappmessaging.runtime.data.requests.ImpressionRequest { *; }
-keep class com.google.android.gms.dynamic.IObjectWrapper { *; }
-keep class jp.co.rakuten.sdtd.user.challenges.internal.get.challenge.Request { *; }

##########################
#                        #
#  Runtime dependencies  #
#                        #
##########################

##------------------------------------------- Gson  ----------------------------------------
# see https://github.com/google/gson/blob/master/examples/android-proguard-example/proguard.cfg
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
#-keepattributes Signature

# Gson specific classes
-keep class sun.misc.Unsafe { *; }

##------------------------------------------- Retrofit  -----------------------------------
# Retrofit does reflection on generic parameters. InnerClasses is required to use Signature and
# EnclosingMethod is required to use InnerClasses.
-keepattributes Signature, InnerClasses, EnclosingMethod

# Retrofit does reflection on method and parameter annotations.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations

# Retain service method parameters when optimizing.
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# Ignore annotation used for build tooling.
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Ignore JSR 305 annotations for embedding nullability information.
-dontwarn javax.annotation.**

# Guarded by a NoClassDefFoundError try/catch and only used when on the classpath.
-dontwarn kotlin.Unit

# Top-level functions that can only be used by Kotlin.
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*

# With R8 full mode, it sees no subtypes of Retrofit interfaces since they are created with a Proxy
# and replaces all potential values with null. Explicitly keeping the interfaces prevents this.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>

##------------------------------------------- OkHttp3  -----------------------------------
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn org.conscrypt.**
# A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
# Repeated in Retrofit.
#-dontwarn javax.annotation.**
-dontwarn okhttp3.internal.platform.ConscryptPlatform

##------------------------------------- Android Support Design  -----------------------------------
#@link http://stackoverflow.com/a/31028536
-dontwarn android.support.design.**
-keep class android.support.design.** { *; }
-keep interface android.support.design.** { *; }
-keep public class android.support.design.R$* { *; }

# For Magnifier
-dontwarn android.widget.**

####################
#                  #
#  Debug use only  #
#                  #
####################

#-keepattributes SourceFile,LineNumberTable