package br.com.oiti.flutter.liveness2d.bridge.utils

import android.content.Context
import android.content.Intent
import br.com.oiti.certiface.data.FaceCaptchaErrorCode
import br.com.oiti.certiface.facecaptcha.FaceCaptchaActivity
import br.com.oiti.certiface.facecaptcha.UserData
import io.flutter.plugin.common.MethodChannel

class FaceCaptchaManager(
    private var context: Context,
    private val userData: UserData,
    private val endpoint: String
): Manageable {

    override fun getIntent(): Intent {
        return Intent(context, FaceCaptchaActivity::class.java).apply {
            putExtra(FaceCaptchaActivity.PARAM_ENDPOINT, endpoint)
            putExtra(FaceCaptchaActivity.PARAM_USER_DATA, userData)
            putExtra(FaceCaptchaActivity.PARAM_DEBUG_ON, false)
        }
    }

    override fun onResultSuccess(data: Intent?, result: MethodChannel.Result?) {
        val codID = data?.getDoubleExtra(FaceCaptchaActivity.PARAM_RESULT_COD_ID, 0.0)
        val response = mapOf<String, Any?>(
            "valid" to data?.getBooleanExtra(FaceCaptchaActivity.PARAM_RESULT, false),
            "cause" to data?.getStringExtra(FaceCaptchaActivity.PARAM_RESULT_CAUSE),
            "cod_id" to codID.toString(),
            "uid_protocol" to data?.getStringExtra(FaceCaptchaActivity.PARAM_RESULT_PROTOCOL),
        )

        result?.success(response)
    }

    override fun onResultCancelled(data: Intent?, result: MethodChannel.Result?) {
        val rawErrorCode = data?.getSerializableExtra(FaceCaptchaActivity.PARAM_RESULT_ERROR_CODE) as? FaceCaptchaErrorCode
        val errorCode = rawErrorCode?.toString() ?: ""
        val errorMessage = data?.getStringExtra(FaceCaptchaActivity.PARAM_RESULT_ERROR)

        result?.error(errorCode, errorMessage, null)
    }
}