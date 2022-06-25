//
//  NetworkConfig.swift
//
//  Created by PAUL SOTO on 12/06/2020.
//  Copyright © 2020 PAUL SOTO. All rights reserved.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}
