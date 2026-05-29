import AudioToolbox
import ExpoModulesCore

public class IsMutedModule: Module {
  private var muteChecker: MuteChecker?

  public func definition() -> ModuleDefinition {
    Name("IsMuted")

    // No automated iOS tests: mute detection relies on AudioServicesPlaySystemSound
    // timing on a physical device with a real ringer switch. Verified manually via the
    // example app. See CONTRIBUTING.md.
    AsyncFunction("isMuted") { (promise: Promise) in
      #if targetEnvironment(simulator)
      promise.reject(
        "ERR_SIMULATOR_UNSUPPORTED",
        "The simulator does not support react-native-is-muted."
      )
      #else
      do {
        let checker = try MuteChecker { [weak self] muted in
          promise.resolve(muted)
          self?.muteChecker = nil
        }
        self.muteChecker = checker
        checker.check()
      } catch {
        promise.reject("ERR_IS_MUTED", error.localizedDescription)
      }
      #endif
    }
  }
}

private final class MuteChecker {
  enum MuteCheckerError: LocalizedError {
    case soundFileMissing
    case soundIdCreationFailed(OSStatus)

    var errorDescription: String? {
      switch self {
      case .soundFileMissing:
        return "MuteChecker.caf was not found in the module bundle."
      case .soundIdCreationFailed(let status):
        return "Failed to create system sound (status \(status))."
      }
    }
  }

  private var soundId: SystemSoundID = 0
  private let completion: (Bool) -> Void
  private var startTime: Date?

  init(completion: @escaping (Bool) -> Void) throws {
    self.completion = completion

    guard let url = Bundle(for: MuteChecker.self).url(forResource: "MuteChecker", withExtension: "caf") else {
      throw MuteCheckerError.soundFileMissing
    }

    let status = AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
    guard status == kAudioServicesNoError else {
      throw MuteCheckerError.soundIdCreationFailed(status)
    }

    var yes: UInt32 = 1
    AudioServicesSetProperty(
      kAudioServicesPropertyIsUISound,
      UInt32(MemoryLayout.size(ofValue: soundId)),
      &soundId,
      UInt32(MemoryLayout.size(ofValue: yes)),
      &yes
    )

    AudioServicesAddSystemSoundCompletion(
      soundId,
      CFRunLoopGetMain(),
      CFRunLoopMode.defaultMode.rawValue,
      { _, clientData in
        guard let clientData else { return }
        Unmanaged<MuteChecker>.fromOpaque(clientData).takeUnretainedValue().completed()
      },
      Unmanaged.passUnretained(self).toOpaque()
    )
  }

  deinit {
    AudioServicesRemoveSystemSoundCompletion(soundId)
    AudioServicesDisposeSystemSoundID(soundId)
  }

  func check() {
    startTime = Date()
    AudioServicesPlaySystemSound(soundId)
  }

  private func completed() {
    let elapsed = Date().timeIntervalSince(startTime ?? Date())
    completion(elapsed <= 0.1)
  }
}
