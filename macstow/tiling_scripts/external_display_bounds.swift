import CoreGraphics
import Darwin

var displayCount: UInt32 = 0
CGGetActiveDisplayList(0, nil, &displayCount)

var displays = Array(repeating: CGDirectDisplayID(0), count: Int(displayCount))
CGGetActiveDisplayList(displayCount, &displays, &displayCount)

let externalDisplays = displays.filter { CGDisplayIsBuiltin($0) == 0 }
guard let display = externalDisplays.first(where: { $0 == CGMainDisplayID() }) ?? externalDisplays.first else {
    fputs("No active external display found\n", stderr)
    exit(EXIT_FAILURE)
}

let bounds = CGDisplayBounds(display)
print("\(Int(bounds.origin.x)),\(Int(bounds.origin.y)),\(Int(bounds.width)),\(Int(bounds.height))")
