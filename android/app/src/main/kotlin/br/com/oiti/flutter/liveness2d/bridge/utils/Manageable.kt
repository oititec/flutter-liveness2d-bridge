package br.com.oiti.flutter.liveness2d.bridge.utils

import android.content.Intent
import io.flutter.plugin.common.MethodChannel

interface Manageable {
    fun getIntent(): Intent
    fun onResultSuccess(data: Intent?, result: MethodChannel.Result?)
    fun onResultCancelled(data: Intent?, result: MethodChannel.Result?)
}