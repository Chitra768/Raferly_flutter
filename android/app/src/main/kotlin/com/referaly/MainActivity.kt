package com.referaly

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.branch.referral.Branch
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.sql.DriverManager.println

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize Branch SDK session on cold start
        Branch.sessionBuilder(this).withCallback { referringParams, error ->
            if (error == null) {
                println("🌿 Branch cold start params: $referringParams")
            } else {
                println("❌ Branch error: $error")
            }
        }.withData(this.intent?.data).init()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // Pass deep link intent when app is already running
        this.setIntent(intent)

        Branch.sessionBuilder(this).withCallback { referringParams, error ->
            if (error == null) {
                println("🌿 Branch new intent params: $referringParams")
            } else {
                println("❌ Branch error (new intent): $error")
            }
        }.reInit()
    }
}
