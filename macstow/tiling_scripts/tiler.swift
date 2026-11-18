import AppKit
import ApplicationServices
import CoreGraphics

let ownPID = ProcessInfo.processInfo.processIdentifier

func currentTargetPID() -> pid_t? {
    if let frontmostApplication = NSWorkspace.shared.frontmostApplication,
       frontmostApplication.processIdentifier != ownPID {
        return frontmostApplication.processIdentifier
    }

    guard let windows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[String: Any]] else {
        return nil
    }
    for window in windows where (window[kCGWindowLayer as String] as? Int) == 0 {
        guard let pidNumber = window[kCGWindowOwnerPID as String] as? NSNumber else {
            continue
        }
        let pid = pidNumber.int32Value
        if pid != ownPID, NSRunningApplication(processIdentifier: pid) != nil {
            return pid
        }
    }
    return nil
}

func showError(_ title: String, _ message: String) -> Never {
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = message
    alert.addButton(withTitle: "OK")
    alert.runModal()
    exit(1)
}

guard let targetPID = currentTargetPID() else {
    showError("Unable to Tile Window", "Could not identify the frontmost application.")
}

final class ColumnPrompt: NSObject {
    let window: NSWindow
    let field: NSTextField

    override init() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 460, height: 320),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        field = NSTextField(string: "11")
        super.init()

        window.title = "Tile Window"
        window.isReleasedWhenClosed = false

        let content = NSView(frame: NSRect(x: 0, y: 0, width: 460, height: 320))
        window.contentView = content

        let instructions = NSTextField(
            wrappingLabelWithString: """
Choose which screen columns the window should cover.

The screen is split into three equal columns:
1 | 2 | 3

Enter the first and last column as two digits:
11 = column 1 only (left third)
12 = columns 1-2 (left two-thirds)
23 = columns 2-3 (right two-thirds)
33 = column 3 only (right third)
"""
        )
        instructions.frame = NSRect(x: 24, y: 138, width: 412, height: 158)
        instructions.alignment = .left
        content.addSubview(instructions)

        field.frame = NSRect(x: 24, y: 94, width: 90, height: 28)
        content.addSubview(field)

        let cancelButton = NSButton(title: "Cancel", target: self, action: #selector(cancel))
        cancelButton.frame = NSRect(x: 250, y: 24, width: 88, height: 32)
        cancelButton.keyEquivalent = "\u{1b}"
        content.addSubview(cancelButton)

        let tileButton = NSButton(title: "Tile", target: self, action: #selector(tile))
        tileButton.frame = NSRect(x: 348, y: 24, width: 88, height: 32)
        tileButton.keyEquivalent = "\r"
        content.addSubview(tileButton)

        window.defaultButtonCell = tileButton.cell as? NSButtonCell
        window.initialFirstResponder = field
    }

    func run() -> NSApplication.ModalResponse {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
        window.center()
        window.makeKeyAndOrderFront(nil)
        guard window.makeFirstResponder(field) else {
            showError("Unable to Focus Input", "The column input field could not be focused.")
        }
        field.selectText(nil)
        let response = NSApplication.shared.runModal(for: window)
        window.orderOut(nil)
        return response
    }

    @objc private func tile() {
        NSApplication.shared.stopModal(withCode: .alertFirstButtonReturn)
    }

    @objc private func cancel() {
        NSApplication.shared.stopModal(withCode: .alertSecondButtonReturn)
    }
}

let prompt = ColumnPrompt()
var firstColumn: Int
var lastColumn: Int
while true {
    guard prompt.run() == .alertFirstButtonReturn else {
        exit(0)
    }

    let digits = Array(prompt.field.stringValue.utf8)
    if digits.count == 2,
       (49...51).contains(digits[0]),
       (49...51).contains(digits[1]) {
        firstColumn = Int(digits[0] - 48)
        lastColumn = Int(digits[1] - 48)
        break
    }

    let invalidAlert = NSAlert()
    invalidAlert.messageText = "Invalid Columns"
    invalidAlert.informativeText = "Enter two digits from 1 to 3.\nExamples: 11, 12, 23, or 33."
    invalidAlert.addButton(withTitle: "OK")
    NSApplication.shared.activate(ignoringOtherApps: true)
    invalidAlert.runModal()
}

if firstColumn > lastColumn {
    swap(&firstColumn, &lastColumn)
}

func attributeValue<T>(_ element: AXUIElement, _ attribute: String) -> T? {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
        return nil
    }
    return value as? T
}

func booleanAttribute(_ element: AXUIElement, _ attribute: String) -> Bool? {
    guard let value: NSNumber = attributeValue(element, attribute) else {
        return nil
    }
    return value.boolValue
}

func findTargetWindow(pid: pid_t) -> AXUIElement? {
    let application = AXUIElementCreateApplication(pid)
    guard let windows: [AXUIElement] = attributeValue(application, kAXWindowsAttribute as String) else {
        return nil
    }

    if let focusedWindow = windows.first(where: { booleanAttribute($0, kAXFocusedAttribute as String) == true }) {
        return focusedWindow
    }
    if let mainWindow = windows.first(where: { booleanAttribute($0, kAXMainAttribute as String) == true }) {
        return mainWindow
    }
    return windows.first { window in
        let subrole: String? = attributeValue(window, kAXSubroleAttribute as String)
        let minimized = booleanAttribute(window, kAXMinimizedAttribute as String) == true
        return (subrole == nil || subrole == kAXStandardWindowSubrole as String) && !minimized
    }
}

guard AXIsProcessTrusted() else {
    showError(
        "Accessibility Access Required",
        "Allow Tiler access in System Settings > Privacy & Security > Accessibility, then try again."
    )
}

guard let targetWindow = findTargetWindow(pid: targetPID) else {
    showError("Unable to Tile Window", "No placeable window was found in the frontmost application.")
}

guard let screen = NSScreen.screens.first else {
    fatalError("No screen was found.")
}

let screenWidth = screen.frame.width
let screenHeight = screen.frame.height
let columnWidth = screenWidth / 3
let windowLeft = CGFloat(firstColumn - 1) * columnWidth
let windowWidth = CGFloat(lastColumn - firstColumn + 1) * columnWidth

var position = CGPoint(x: windowLeft, y: 25)
var size = CGSize(width: windowWidth, height: screenHeight - 25)
guard let positionValue = AXValueCreate(.cgPoint, &position),
      let sizeValue = AXValueCreate(.cgSize, &size),
      AXUIElementSetAttributeValue(targetWindow, kAXPositionAttribute as CFString, positionValue) == .success,
      AXUIElementSetAttributeValue(targetWindow, kAXSizeAttribute as CFString, sizeValue) == .success else {
    showError(
        "Unable to Tile Window",
        "Allow Tiler access in System Settings > Privacy & Security > Accessibility, then try again."
    )
}

guard NSRunningApplication(processIdentifier: targetPID)?.activate() == true else {
    showError("Unable to Focus Window", "The window's application could not be activated.")
}

guard AXUIElementPerformAction(targetWindow, kAXRaiseAction as CFString) == .success else {
    showError("Unable to Focus Window", "The tiled window could not be brought to the front.")
}
