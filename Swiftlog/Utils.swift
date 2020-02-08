import Foundation
import VPIAssistant

public class Control {
    public static func finish() {
        vpi_finish();
    }
}

extension String {
    public var cPointer: (cLiteral: UnsafePointer<CChar>, cMutable: UnsafeMutablePointer<CChar>, mutable: UnsafeMutablePointer<UInt8>, elementCount: Int) {
        var utf8Representation = Array(self.utf8)
        utf8Representation.append(0) //0 terminator
        let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: utf8Representation.count)
        let cMutablePointer = UnsafeMutableRawPointer(mutablePointer).bindMemory(to: CChar.self, capacity: utf8Representation.count)
        let immutablePointer = UnsafeRawPointer(mutablePointer).bindMemory(to: CChar.self, capacity: utf8Representation.count)       
        let _ = UnsafeMutableBufferPointer<UInt8>(start: mutablePointer, count: utf8Representation.count).initialize(from: utf8Representation)
        return (cLiteral: immutablePointer, cMutable: cMutablePointer, mutable: mutablePointer, elementCount: utf8Representation.count)
    }
}