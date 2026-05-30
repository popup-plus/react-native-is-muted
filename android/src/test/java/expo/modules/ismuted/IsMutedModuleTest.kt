package expo.modules.ismuted

import android.content.Context
import android.media.AudioManager
import androidx.test.core.app.ApplicationProvider
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class IsMutedModuleTest {
  private val audioManager: AudioManager
    get() = ApplicationProvider.getApplicationContext<Context>()
      .getSystemService(Context.AUDIO_SERVICE) as AudioManager

  @Test
  fun normalRingerIsNotMuted() {
    audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
    assertFalse(isAudioMuted(audioManager))
  }

  @Test
  fun silentRingerIsMuted() {
    audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
    assertTrue(isAudioMuted(audioManager))
  }

  @Test
  fun vibrateRingerIsMuted() {
    audioManager.ringerMode = AudioManager.RINGER_MODE_VIBRATE
    assertTrue(isAudioMuted(audioManager))
  }
}
