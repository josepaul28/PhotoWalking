//
//  ResponseDecoder.swift
//
//  Created by PAUL SOTO on 16/2/21.
//  Copyright © 2021 PAUL SOTO. All rights reserved.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
