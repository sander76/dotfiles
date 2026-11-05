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

guard let targetPID = currentTargetPID() else {
    let errorAlert = NSAlert()
    errorAlert.messageText = "Unable to Tile Window"
    errorAlert.informativeText = "Could not identify the frontmost application."
    errorAlert.addButton(withTitle: "OK")
    errorAlert.runModal()
    exit(1)
}

let alert = NSAlert()
alert.messageText = "Tile Window"
alert.informativeText = """
Choose which screen columns the window should cover.

The screen is split into three equal columns:
1 | 2 | 3

Enter the first and last column as two digits:
11 = column 1 only (left third)
12 = columns 1-2 (left two-thirds)
23 = columns 2-3 (right two-thirds)
33 = column 3 only (right third)
"""
alert.addButton(withTitle: "Tile")
alert.addButton(withTitle: "Cancel")

let columnField = NSTextField(string: "11")
columnField.frame = NSRect(x: 0, y: 0, width: 80, height: 24)
alert.accessoryView = columnField

var firstColumn: Int
var lastColumn: Int
while true {
    guard alert.runModal() == .alertFirstButtonReturn else {
        exit(0)
    }

    let placement = columnField.stringValue
    let digits = Array(placement.utf8)
    if digits.count == 2,
       (49...51).contains(digits[0]),
       (49...51).contains(digits[1]) {
        let first = Int(digits[0] - 48)
        let last = Int(digits[1] - 48)
        firstColumn = first
        lastColumn = last
        break
    }

    let invalidAlert = NSAlert()
    invalidAlert.messageText = "Invalid Columns"
    invalidAlert.informativeText = "Enter two digits from 1 to 3.\nExamples: 11, 12, 23, or 33."
    invalidAlert.addButton(withTitle: "OK")
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
    let errorAlert = NSAlert()
    errorAlert.messageText = "Accessibility Access Required"
    errorAlert.informativeText = "Allow Tiler access in System Settings > Privacy & Security > Accessibility, then try again."
    errorAlert.addButton(withTitle: "OK")
    errorAlert.runModal()
    exit(1)
}

guard let targetWindow = findTargetWindow(pid: targetPID) else {
    let errorAlert = NSAlert()
    errorAlert.messageText = "Unable to Tile Window"
    errorAlert.informativeText = "No placeable window was found in the frontmost application."
    errorAlert.addButton(withTitle: "OK")
    errorAlert.runModal()
    exit(1)
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
    let errorAlert = NSAlert()
    errorAlert.messageText = "Unable to Tile Window"
    errorAlert.informativeText = "Allow Tiler access in System Settings > Privacy & Security > Accessibility, then try again."
    errorAlert.addButton(withTitle: "OK")
    errorAlert.runModal()
    exit(1)
}
