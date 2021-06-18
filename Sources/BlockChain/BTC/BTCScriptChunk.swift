//
//  BTCScriptChunk.swift
//  Galaxy
//
//  Created by galaxy on 2021/6/17.
//

import Foundation

public class BTCScriptChunk {
    public private(set) var range: ClosedRange<Int> = 0...0
    public private(set) var scriptData: Data = Data()
    
    /// Opcode used in the chunk. Simply a first byte of its raw data.
    public var opcode: BTCOPCode {
        let bytes = scriptData.gl.bytes
        if range.lowerBound < bytes.count &&
            range.lowerBound >= 0 &&
            bytes.count >= 1 {
            let byte = bytes[range.lowerBound]
            return BTCOPCode(rawValue: byte) ?? .OP_INVALIDOPCODE
        }
        return .OP_INVALIDOPCODE
    }
    
    /// Return YES if it is not a pushdata chunk, that is a single byte opcode without data.
    /// -data returns nil when the value is YES.
    public var isOPCode: Bool {
        // Pushdata opcodes are not considered a single "opcode".
        // Attention: OP_0 is also "pushdata" code that pushes empty data.
        if opcode.rawValue <= BTCOPCode.OP_PUSHDATA4.rawValue {
            return false
        }
        return true
    }
    
    public var chunkData: Data {
        let bytes = scriptData.gl.bytes
        if (range.lowerBound < bytes.count && range.lowerBound >= 0 && bytes.count >= 1) &&
            (range.upperBound < bytes.count && range.upperBound >= 0 && bytes.count >= 1) &&
            range.lowerBound <= range.upperBound {
            return scriptData[range]
        }
        return Data()
    }
    
    // Data being pushed. Returns nil if the opcode is not OP_PUSHDATA*.
    public var pushdData: Data? {
        if isOPCode {
            return nil
        }
        let opcode = self.opcode
        var loc: Int = 1
        if opcode.rawValue == BTCOPCode.OP_PUSHDATA1.rawValue {
            loc += 1
        } else if opcode.rawValue == BTCOPCode.OP_PUSHDATA2.rawValue {
            loc += 2
        } else if opcode.rawValue == BTCOPCode.OP_PUSHDATA4.rawValue {
            loc += 4
        }
        let bytes = scriptData.gl.bytes
        if (range.lowerBound < bytes.count && range.lowerBound >= 0 && bytes.count >= 1) &&
            (range.upperBound < bytes.count && range.upperBound >= 0 && bytes.count >= 1) &&
            (range.lowerBound + loc < bytes.count) &&
            (range.lowerBound + loc <= range.upperBound) &&
            range.lowerBound <= range.upperBound {
            let newRange = (range.lowerBound)...range.upperBound
            return scriptData[newRange]
        }
        return nil
    }
    
    /// Returns `YES` if the data is represented with the most compact opcode.
    public var isDataCompact: Bool {
        if isOPCode {
            return false
        }
        let opcode = self.opcode
        guard let pushdData = self.pushdData else {
            return false
        }
        if opcode.rawValue < BTCOPCode.OP_PUSHDATA1.rawValue {
            // length fits in one byte under OP_PUSHDATA1.
            return true
        } else if opcode.rawValue == BTCOPCode.OP_PUSHDATA1.rawValue {
            // length should be less than OP_PUSHDATA1
            return pushdData.count >= BTCOPCode.OP_PUSHDATA1.rawValue
        } else if opcode.rawValue == BTCOPCode.OP_PUSHDATA2.rawValue {
            // length should not fit in one byte
            return pushdData.count > 0xff
        } else if opcode.rawValue == BTCOPCode.OP_PUSHDATA4.rawValue {
            // length should not fit in two bytes
            return pushdData.count > 0xffff
        }
        return false
    }
    
    // String representation of a chunk.
    // OP_1NEGATE, OP_0, OP_1..OP_16 are represented as a decimal number.
    // Most compactly represented pushdata chunks >=128 bit are encoded as <hex string>
    // Smaller most compactly represented data is encoded as [<hex string>]
    // Non-compact pushdata (e.g. 75-byte string with PUSHDATA1) contains a decimal prefix denoting a length size before hex data in square brackets. Ex. "1:[...]", "2:[...]" or "4:[...]"
    // For both compat and non-compact pushdata chunks, if the data consists of all printable characters (0x20..0x7E), it is enclosed not in square brackets, but in single quotes as characters themselves. Non-compact string is prefixed with 1:, 2: or 4: like described above.

    // Some other guys (BitcoinQT, bitcoin-ruby) encode "small enough" integers in decimal numbers and do that differently.
    // BitcoinQT encodes any data less than 4 bytes as a decimal number.
    // bitcoin-ruby encodes 2..16 as decimals, 0 and -1 as opcode names and the rest is in hex.
    // Now no matter which encoding you use, it can be parsed incorrectly.
    // Also: pushdata operations are typically encoded in a raw data which can be encoded in binary differently.
    // This means, you'll never be able to parse a sane-looking script into only one binary.
    // So forget about relying on parsing this thing exactly. Typically, we either have very small numbers (0..16),
    // or very big numbers (hashes and pubkeys).
    public var string: String? {
        let opcode = self.opcode
        if isOPCode {
            if opcode == .OP_0 || opcode == .OP_1NEGATE {
                return BTCNameForOPCode(opcode)
            }
            if opcode.rawValue >= BTCOPCode.OP_1.rawValue && opcode.rawValue <= BTCOPCode.OP_16.rawValue {
                return "OP_" + "\(opcode.rawValue + 1 - BTCOPCode.OP_1.rawValue)"
            } else {
                return BTCNameForOPCode(opcode)
            }
        } else {
            // OP_0 = 0x00
            // OP_FALSE = OP_0
            // OP_PUSHDATA1 = 0x4c
            // OP_PUSHDATA2 = 0x4d
            // OP_PUSHDATA4 = 0x4e
            let data = pushdData ?? Data()
            var result: String? = nil
            if data.count == 0 {
                result = "OP_0"
            } else if isDisplayASCIIData(data: data) {
                result = String(data: data, encoding: .ascii)
                if result != nil {
                    // Escape escapes & single quote characters.
                    result = result!.replacingOccurrences(of: "\\", with: "\\\\")
                    result = result!.replacingOccurrences(of: "'", with: "\\'")
                    // Wrap in single quotes. Why not double? Because they are already used in JSON and we don't want to multiply the mess.
                    result = "'\(result!)'"
                }
            } else {
                result = data.gl.toHexString
                // Shorter than 128-bit chunks are wrapped in square brackets to avoid ambiguity with big all-decimal numbers.
                if data.count < 16 && result != nil {
                    result = "[\(result!)]"
                }
            }
            // Non-compact data is prefixed with an appropriate length prefix.
            if !isDataCompact && result != nil {
                var prefix: Int = 1
                if opcode == .OP_PUSHDATA2 {
                    prefix = 2
                }
                if opcode == .OP_PUSHDATA4 {
                    prefix = 4
                }
                result = "\(prefix):\(result!)"
            }
            return result
        }
    }
    
    
    
    
    
    
    
    
    init() {
        for (a, b) in range.enumerated() {
            
        }
    }
    
}

extension BTCScriptChunk {
    /// 是否是可显示的ASCII（十进制的32-126）
    public func isDisplayASCIIData(data: Data) -> Bool {
        var isASCII = true
        for byte in [UInt8](data) {
            if !(byte >= 0x20 && byte <= 0x7e) {
                isASCII = false
                break
            }
        }
        
        return isASCII
    }
    
    public func scriptDataForPushdata(data: Data?) -> Data? {
        guard let data = data else { return nil }
        if data.count < BTCOPCode.OP_PUSHDATA1.rawValue {
            let len: UInt8 = UInt8(data.count)
            var resultData = Data()
            resultData += Data([len]) // 长度
            resultData += data // 数据
            return resultData
        } else if data.count <= 0xff {
            let len: UInt8 = UInt8(data.count)
            var resultData = Data()
            resultData += Data([BTCOPCode.OP_PUSHDATA1.rawValue]) // 操作码
            resultData += Data([len]) // 长度
            resultData += data // 数据
            return resultData
        } else if data.count <= 0xffff {
            let len: UInt16 = UInt16(data.count)
            var resultData = Data()
            resultData += Data([BTCOPCode.OP_PUSHDATA2.rawValue]) // 操作码
            resultData += len.gl.littleEndianSerialize(to: UInt8.self) // 长度(小端模式)
            resultData += data // 数据
            return resultData
        } else if data.count <= 0xffffffff {
            let len: UInt32 = UInt32(data.count)
            var resultData = Data()
            resultData += Data([BTCOPCode.OP_PUSHDATA4.rawValue]) // 操作码
            resultData += len.gl.littleEndianSerialize(to: UInt8.self) // 长度(小端模式)
            resultData += data // 数据
            return resultData
        }
        return nil
    }
}
