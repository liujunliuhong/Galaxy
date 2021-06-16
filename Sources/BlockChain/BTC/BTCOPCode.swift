//
//  BTCOPCode.swift
//  Galaxy
//
//  Created by liujun on 2021/6/11.
//

import Foundation

/// https://lilong.net/MasterBitcoinSV/ch06.html#_6-4-%E6%AF%94%E7%89%B9%E5%B8%81%E4%BA%A4%E6%98%93%E8%84%9A%E6%9C%AC%E5%92%8C%E8%84%9A%E6%9C%AC%E8%AF%AD%E8%A8%80
/// https://github.com/tianmingyun/MasterBitcoin2CN/blob/master/appdx-scriptops.md
/// https://en.bitcoin.it/wiki/Script

public struct BTCOPCode {
    
    public enum OPCode {
        // Push 1 byte 0x00 on the stack
        case OP_0
        case OP_FALSE
        
        // PUSHDATA<N> opcode is followed by N-byte length of the string that follows.
        case OP_PUSHDATA1
        case OP_PUSHDATA2
        case OP_PUSHDATA4
        case OP_1NEGATE
        case OP_RESERVED
        
        // OP_<N> pushes number <N> on the stack
        case OP_1
        case OP_TRUE
        case OP_2
        case OP_3
        case OP_4
        case OP_5
        case OP_6
        case OP_7
        case OP_8
        case OP_9
        case OP_10
        case OP_11
        case OP_12
        case OP_13
        case OP_14
        case OP_15
        case OP_16
        
        // Control flow operators
        case OP_NOP
        case OP_VER
        
        // BitcoinQT executes all operators from OP_IF to OP_ENDIF even inside "non-executed" branch (to keep track of nesting).
        // Since OP_VERIF and OP_VERNOTIF are not assigned, even inside a non-executed branch they will fall in "default:" switch case
        // and cause the script to fail. Some other ops like OP_VER can be present inside non-executed branch because they'll be skipped.
        case OP_IF
        case OP_NOTIF
        case OP_VERIF
        case OP_VERNOTIF
        case OP_ELSE
        case OP_ENDIF
        
        case OP_VERIFY
        case OP_RETURN
        
        // Stack ops
        case OP_TOALTSTACK
        case OP_FROMALTSTACK
        case OP_2DROP
        case OP_2DUP
        case OP_3DUP
        case OP_2OVER
        case OP_2ROT
        case OP_2SWAP
        case OP_IFDUP
        case OP_DEPTH
        case OP_DROP
        case OP_DUP
        case OP_NIP
        case OP_OVER
        case OP_PICK
        case OP_ROLL
        case OP_ROT
        case OP_SWAP
        case OP_TUCK
        
        // Splice ops
        case OP_CAT
        case OP_SUBSTR
        case OP_LEFT
        case OP_RIGHT
        case OP_SIZE
        
        // Bit logic
        case OP_INVERT
        case OP_AND
        case OP_OR
        case OP_XOR
        
        case OP_EQUAL
        case OP_EQUALVERIFY
        
        case OP_RESERVED1
        case OP_RESERVED2
        
        // Numeric
        case OP_1ADD
        case OP_1SUB
        case OP_2MUL
        case OP_2DIV
        case OP_NEGATE
        case OP_ABS
        case OP_NOT
        case OP_0NOTEQUAL
        
        case OP_ADD
        case OP_SUB
        case OP_MUL
        case OP_DIV
        case OP_MOD
        case OP_LSHIFT
        case OP_RSHIFT
        
        case OP_BOOLAND
        case OP_BOOLOR
        case OP_NUMEQUAL
        case OP_NUMEQUALVERIFY
        case OP_NUMNOTEQUAL
        case OP_LESSTHAN
        case OP_GREATERTHAN
        case OP_LESSTHANOREQUAL
        case OP_GREATERTHANOREQUAL
        case OP_MIN
        case OP_MAX
        
        case OP_WITHIN
        
        // Crypto
        case OP_RIPEMD160
        case OP_SHA1
        case OP_SHA256
        case OP_HASH160
        case OP_HASH256
        case OP_CODESEPARATOR
        case OP_CHECKSIG
        case OP_CHECKSIGVERIFY
        case OP_CHECKMULTISIG
        case OP_CHECKMULTISIGVERIFY
        
        // Expansion
        case OP_NOP1
        case OP_NOP2
        case OP_NOP3
        case OP_NOP4
        case OP_NOP5
        case OP_NOP6
        case OP_NOP7
        case OP_NOP8
        case OP_NOP9
        case OP_NOP10
        
        case OP_INVALIDOPCODE
    }
}

extension BTCOPCode.OPCode {
    public var value: UInt8 {
        switch self {
        case .OP_0: return 0x00
        case .OP_FALSE: return 0x00
        case .OP_PUSHDATA1: return 0x4c
        case .OP_PUSHDATA2: return 0x4d
        case .OP_PUSHDATA4: return 0x4e
        case .OP_1NEGATE: return 0x4f
        case .OP_RESERVED: return 0x50
        case .OP_1: return 0x51
        case .OP_TRUE: return 0x51
        case .OP_2: return 0x52
        case .OP_3: return 0x53
        case .OP_4: return 0x54
        case .OP_5: return 0x55
        case .OP_6: return 0x56
        case .OP_7: return 0x57
        case .OP_8: return  0x58
        case .OP_9: return 0x59
        case .OP_10: return 0x5a
        case .OP_11: return 0x5b
        case .OP_12: return 0x5c
        case .OP_13: return 0x5d
        case .OP_14: return 0x5e
        case .OP_15: return 0x5f
        case .OP_16: return 0x60
        case .OP_NOP: return 0x61
        case .OP_VER: return 0x62
        case .OP_IF: return 0x63
        case .OP_NOTIF: return 0x64
        case .OP_VERIF: return 0x65
        case .OP_VERNOTIF: return 0x66
        case .OP_ELSE: return 0x67
        case .OP_ENDIF: return 0x68
        case .OP_VERIFY: return 0x69
        case .OP_RETURN: return 0x6a
        case .OP_TOALTSTACK: return 0x6b
        case .OP_FROMALTSTACK: return 0x6c
        case .OP_2DROP: return 0x6d
        case .OP_2DUP: return 0x6e
        case .OP_3DUP: return 0x6f
        case .OP_2OVER: return 0x70
        case .OP_2ROT: return 0x71
        case .OP_2SWAP: return 0x72
        case .OP_IFDUP: return 0x73
        case .OP_DEPTH: return 0x74
        case .OP_DROP: return 0x75
        case .OP_DUP: return 0x76
        case .OP_NIP: return 0x77
        case .OP_OVER: return 0x78
        case .OP_PICK: return 0x79
        case .OP_ROLL: return 0x7a
        case .OP_ROT: return 0x7b
        case .OP_SWAP: return 0x7c
        case .OP_TUCK: return 0x7d
        case .OP_CAT: return 0x7e
        case .OP_SUBSTR: return 0x7f
        case .OP_LEFT: return 0x80
        case .OP_RIGHT: return 0x81
        case .OP_SIZE: return 0x82
        case .OP_INVERT: return 0x83
        case .OP_AND: return 0x84
        case .OP_OR: return 0x85
        case .OP_XOR: return 0x86
        case .OP_EQUAL: return 0x87
        case .OP_EQUALVERIFY: return 0x88
        case .OP_RESERVED1: return 0x89
        case .OP_RESERVED2: return 0x8a
        case .OP_1ADD: return 0x8b
        case .OP_1SUB: return 0x8c
        case .OP_2MUL: return 0x8d
        case .OP_2DIV: return 0x8e
        case .OP_NEGATE: return 0x8f
        case .OP_ABS: return 0x90
        case .OP_NOT: return 0x91
        case .OP_0NOTEQUAL: return 0x92
        case .OP_ADD: return 0x93
        case .OP_SUB: return 0x94
        case .OP_MUL: return 0x95
        case .OP_DIV: return 0x96
        case .OP_MOD: return 0x97
        case .OP_LSHIFT: return 0x98
        case .OP_RSHIFT: return 0x99
        case .OP_BOOLAND: return 0x9a
        case .OP_BOOLOR: return 0x9b
        case .OP_NUMEQUAL: return 0x9c
        case .OP_NUMEQUALVERIFY: return 0x9d
        case .OP_NUMNOTEQUAL: return 0x9e
        case .OP_LESSTHAN: return 0x9f
        case .OP_GREATERTHAN: return 0xa0
        case .OP_LESSTHANOREQUAL: return 0xa1
        case .OP_GREATERTHANOREQUAL: return 0xa2
        case .OP_MIN: return 0xa3
        case .OP_MAX: return 0xa4
        case .OP_WITHIN: return 0xa5
        case .OP_RIPEMD160: return 0xa6
        case .OP_SHA1: return 0xa7
        case .OP_SHA256: return 0xa8
        case .OP_HASH160: return 0xa9
        case .OP_HASH256: return 0xaa
        case .OP_CODESEPARATOR: return 0xab
        case .OP_CHECKSIG: return 0xac
        case .OP_CHECKSIGVERIFY: return 0xad
        case .OP_CHECKMULTISIG: return 0xae
        case .OP_CHECKMULTISIGVERIFY: return 0xaf
        case .OP_NOP1: return 0xb0
        case .OP_NOP2: return 0xb1
        case .OP_NOP3: return 0xb2
        case .OP_NOP4: return 0xb3
        case .OP_NOP5: return 0xb4
        case .OP_NOP6: return 0xb5
        case .OP_NOP7: return 0xb6
        case .OP_NOP8: return 0xb7
        case .OP_NOP9: return 0xb8
        case .OP_NOP10: return 0xb9
        case .OP_INVALIDOPCODE: return 0xff
        }
    }
}
