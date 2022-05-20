//
//  Data+Extension.swift
//  sapco
//
//  Created by Taopd on 03/08/2018.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation

extension Data {
    init(reading input: InputStream) {
        self.init()
        input.open()

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate()
        input.close()
    }
}
