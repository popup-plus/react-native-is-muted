package expo.modules.ismuted

import android.content.Context
import android.media.AudioManager
import androidx.annotation.VisibleForTesting
import expo.modules.kotlin.exception.CodedException
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class IsMutedModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("IsMuted")

    AsyncFunction("isMuted") {
      val context = appContext.reactContext
        ?: throw CodedException("ERR_IS_MUTED", "React context is unavailable.", null)
      val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
      isAudioMuted(audioManager)
    }
  }
}

@VisibleForTesting
internal fun isAudioMuted(audioManager: AudioManager): Boolean =
  audioManager.ringerMode != AudioManager.RINGER_MODE_NORMAL
