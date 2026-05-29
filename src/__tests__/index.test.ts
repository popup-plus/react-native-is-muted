import { requireNativeModule } from "expo";

import IsMutedModule from "../IsMutedModule";
import { isMuted } from "../index";

jest.mock("expo", () => {
  const isMutedFn = jest.fn();
  class NativeModule {}
  return {
    NativeModule,
    requireNativeModule: jest.fn(() => ({ isMuted: isMutedFn })),
    __isMutedFn: isMutedFn,
  };
});

const mockIsMuted = (jest.requireMock("expo") as { __isMutedFn: jest.Mock })
  .__isMutedFn;

describe("isMuted", () => {
  beforeEach(() => {
    mockIsMuted.mockReset();
  });

  it("resolves to true when the native module reports muted", async () => {
    mockIsMuted.mockResolvedValueOnce(true);
    await expect(isMuted()).resolves.toBe(true);
    expect(mockIsMuted).toHaveBeenCalledTimes(1);
    expect(mockIsMuted).toHaveBeenCalledWith();
  });

  it("resolves to false when the native module reports not muted", async () => {
    mockIsMuted.mockResolvedValueOnce(false);
    await expect(isMuted()).resolves.toBe(false);
  });

  it("propagates rejections from the native module", async () => {
    mockIsMuted.mockRejectedValueOnce(new Error("ERR_SIMULATOR_UNSUPPORTED"));
    await expect(isMuted()).rejects.toThrow("ERR_SIMULATOR_UNSUPPORTED");
  });

  it("resolves the native module under the 'IsMuted' name", () => {
    expect(requireNativeModule).toHaveBeenCalledWith("IsMuted");
  });

  it("default-exports the native module", () => {
    expect(IsMutedModule.isMuted).toBe(mockIsMuted);
  });
});
