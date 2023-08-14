package br.com.oiti.flutter.liveness2d.bridge.utils

import android.content.Context
import android.content.Intent
import br.com.oiti.certiface.data.util.CertifaceEnviroment
import br.com.oiti.certiface.documentscopy.DocumentscopyActivity
import br.com.oiti.certiface.documentscopy.DocumentscopyErrorCode
import io.flutter.plugin.common.MethodChannel

class DocumentscopyManager(
    private var context: Context,
    private val ticket: String?,
    private val appKey: String,
    private val endpoint: String,
    private val environment: CertifaceEnviroment
): Manageable {

    override fun getIntent(): Intent {
        return Intent(context, DocumentscopyActivity::class.java).apply {
            putExtra(DocumentscopyActivity.PARAM_TICKET, ticket)
            putExtra(DocumentscopyActivity.PARAM_APP_KEY, appKey)
            putExtra(DocumentscopyActivity.PARAM_ENDPOINT, endpoint)
            putExtra(DocumentscopyActivity.PARAM_CERTIFACE_ENV, environment)
            putExtra(DocumentscopyActivity.PARAM_DEBUG_ON, false)
        }
    }

    override fun onResultSuccess(data: Intent?, result: MethodChannel.Result?) {
        result?.success(null)
    }

    override fun onResultCancelled(data: Intent?, result: MethodChannel.Result?) {
        val rawErrorCode = data?.getSerializableExtra(DocumentscopyActivity.PARAM_RESULT_ERROR_CODE) as? DocumentscopyErrorCode
        val errorCode = rawErrorCode?.toString() ?: ""
        val errorMessage = data?.getStringExtra(DocumentscopyActivity.PARAM_RESULT_ERROR)

        result?.error(errorCode, errorMessage, null)
    }
}