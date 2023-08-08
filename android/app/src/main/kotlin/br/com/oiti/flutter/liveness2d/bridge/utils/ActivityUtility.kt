package br.com.oiti.flutter.liveness2d.bridge.utils

import br.com.oiti.certiface.data.util.CertifaceEnviroment
import br.com.oiti.certiface.facecaptcha.UserData
import io.flutter.plugin.common.MethodCall

class ActivityUtility {
    companion object {
        fun getArgumentsFrom(call: MethodCall): Triple<String?, String, CertifaceEnviroment> {
            val ticket = call.argument<String?>("ticket")
            val appKey = call.argument<String?>("appkey") ?: ""
            val isProd: Boolean? = call.argument("isProd")
            val environment = when (isProd == true) {
                true -> CertifaceEnviroment.PRD
                else -> CertifaceEnviroment.HML
            }

            return Triple(ticket, appKey, environment)
        }

        fun getEndpointFrom(environment: CertifaceEnviroment): String {
            return when (environment) {
                CertifaceEnviroment.PRD -> "https://certiface.com.br"
                CertifaceEnviroment.HML -> "https://comercial.certiface.com.br"
            }
        }

        fun getUserDataFrom(call: MethodCall, appKey: String): UserData {
            return UserData(
                appKey = appKey,
                user = call.argument<String?>("user") ?: "",
                nome = call.argument<String?>("name") ?: "",
                cpf = call.argument<String?>("cpf") ?: "",
                nascimento = call.argument<String?>("birthdate") ?: "",
                pass = call.argument<String?>("pass") ?: ""
            )
        }
    }
}