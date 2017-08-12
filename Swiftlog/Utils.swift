import Foundation
import VPIAssistant

class Control
{
    static func finish()
    {
        vpi_finish();
    }
}

extension String
{
    var cPointer: (literal: UnsafePointer<CChar>, mutable: UnsafeMutablePointer<UInt8>, elementCount: Int)
    {
        let utf8Representation = Array(self.utf8)
        let mutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: utf8Representation.count)
        let immutablePointer = UnsafeRawPointer(mutablePointer).bindMemory(to: CChar.self, capacity: utf8Representation.count)       
        let _ = UnsafeMutableBufferPointer<UInt8>(start: mutablePointer, count: utf8Representation.count).initialize(from: utf8Representation)
        return (literal: immutablePointer, mutable: mutablePointer, elementCount: utf8Representation.count)
    }
}