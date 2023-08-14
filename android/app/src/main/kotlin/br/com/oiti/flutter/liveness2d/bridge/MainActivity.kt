package br.com.oiti.flutter.liveness2d.bridge

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import br.com.oiti.flutter.liveness2d.bridge.utils.ActivityUtility
import br.com.oiti.flutter.liveness2d.bridge.utils.DocumentscopyManager
import br.com.oiti.flutter.liveness2d.bridge.utils.FaceCaptchaManager
import br.com.oiti.flutter.liveness2d.bridge.utils.Manageable
import java.lang.Exception

class MainActivity : FlutterActivity() {

    companion object {
        private const val FC_RESULT_REQUEST = 9584
        private const val DC_RESULT_REQUEST = 9604
    }

    private var resultFlutter: Result? = null
    private var faceCaptchaManager: Manageable? = null
    private var documentscopyManager: Manageable? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        val channel = MethodChannel(binaryMessenger, "oiti_liveness2d_bridge")

        channel.setMethodCallHandler { call, result ->
            this.resultFlutter = result

            when (call.method) {
                "OITI.startFaceCaptcha" -> {
                    try {
                        startFaceCaptcha(call)
                    } catch (e: Exception) {
                        result.error("UNKNOWN_ERROR", e.message, e.stackTrace)
                    }
                }

                "OITI.startDocumentscopy" -> {
                    try {
                        startDocumentscopy(call)
                    } catch (e: Exception) {
                        result.error("UNKNOWN_ERROR", e.message, e.stackTrace)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun startFaceCaptcha(call: MethodCall) {
        val (_, appKey, environment) = ActivityUtility.getArgumentsFrom(call)
        val endpoint = ActivityUtility.getEndpointFrom(environment)
        val userData = ActivityUtility.getUserDataFrom(call, appKey)
        val manager = FaceCaptchaManager(this, userData, endpoint)

        faceCaptchaManager = manager
        activity.startActivityForResult(manager.getIntent(), FC_RESULT_REQUEST)
    }

    private fun startDocumentscopy(call: MethodCall) {
        val (ticket, appKey, environment) = ActivityUtility.getArgumentsFrom(call)
        val endpoint = ActivityUtility.getEndpointFrom(environment)
        val manager = DocumentscopyManager(this, ticket, appKey, endpoint, environment)

        documentscopyManager = manager
        activity.startActivityForResult(manager.getIntent(), DC_RESULT_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode) {
            FC_RESULT_REQUEST -> {
                when (resultCode) {
                    Activity.RESULT_OK -> faceCaptchaManager?.onResultSuccess(data, resultFlutter)
                    Activity.RESULT_CANCELED -> faceCaptchaManager?.onResultCancelled(data, resultFlutter)
                }
            }

            DC_RESULT_REQUEST -> {
                when (resultCode) {
                    Activity.RESULT_OK -> documentscopyManager?.onResultSuccess(data, resultFlutter)
                    Activity.RESULT_CANCELED -> documentscopyManager?.onResultCancelled(data, resultFlutter)
                }
            }
        }
    }
}
