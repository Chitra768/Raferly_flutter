package com.referaly

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.branch.referral.Branch
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.sql.DriverManager.println

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize Branch SDK session on cold start with null check
        try {
            val branch = Branch.getInstance()
            if (branch != null) {
                Branch.sessionBuilder(this).withCallback { referringParams, error ->
                    if (error == null) {
                        println("🌿 Branch cold start params: $referringParams")
                    } else {
                        println("❌ Branch error: $error")
                    }
                }.withData(this.intent?.data).init()
            } else {
                println("⚠️ Branch SDK not initialized yet")
            }
        } catch (e: Exception) {
            println("❌ Branch initialization error: ${e.message}")
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // Pass deep link intent when app is already running
        this.setIntent(intent)

        // Reinitialize Branch session with null check
        try {
            val branch = Branch.getInstance()
            if (branch != null) {
                Branch.sessionBuilder(this).withCallback { referringParams, error ->
                    if (error == null) {
                        println("🌿 Branch new intent params: $referringParams")
                    } else {
                        println("❌ Branch error (new intent): $error")
                    }
                }.reInit()
            } else {
                println("⚠️ Branch SDK not initialized yet")
            }
        } catch (e: Exception) {
            println("❌ Branch reinit error: ${e.message}")
        }
    }
}
