//
//  ApiDataNetworkConfig.swift
//
//  Created by PAUL SOTO on 30/6/21.
//

import Foundation

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let headers: [String: String]
    let queryParameters: [String: String]

    init(
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:]
    ) {
        self.baseURL = URL(string: Constants.Api.baseUrl)!
        self.headers = headers
        self.queryParameters = queryParameters.merging([
            "api_key": Constants.Api.apiKey,
            "format": "json",
            "nojsoncallback": "1"
        ], uniquingKeysWith: { (current, _) in current })
    }
}
