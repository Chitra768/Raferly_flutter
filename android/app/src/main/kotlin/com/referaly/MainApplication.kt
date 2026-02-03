package com.referaly

import android.app.Application
import io.branch.referral.Branch

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize Branch SDK - getAutoInstance reads keys from AndroidManifest
        Branch.enableLogging()
        Branch.getAutoInstance(applicationContext)
    }
}

