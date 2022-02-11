//
//  Member.swift
//  SwiftUI-WeChat
//
//  Created by Gesen on 2019/11/29.
//  Copyright © 2019 Gesen. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

struct Member: Codable, Equatable, Identifiable {
    var id = UUID()
    var background: String?
    var icon: String
    var identifier: String?
    var name: String
    var description: String
}

extension Member {

    static let swiftui = Member(
        background: nil,
        icon: "data_avatar1",
        identifier: nil,
        name: "SwiftUI",
        description: ""
    )
    
    static let me = Member(
        background: "data_moment_background",
        icon: "person",
        identifier: "Power: 0",
        name: "ABCD",
        description: ""
    )
}
func MD5_data(i_string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = i_string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
}
func MD5_hex(i_string: String) -> String {
    return MD5_data(i_string: i_string).map { String(format: "%02hhx", $0) }.joined()
}
