//
//  AppError.swift
//
//  Created by PAUL SOTO on 30/6/21.
//

import Foundation

public struct AppError {
    public enum Database: Error, Equatable {
        case notAvailable
        case noResults
        case dataError
        case entryNotExist(entity: String, id: String?)
        case writeError
    }

    public enum General: Error {
        case expired
        case unexpected
        case badCodingKey
        case badPayload
        case invalidEditorialContent
        case badDate
        case badTimeZone
        case badTypeCast
        case mapping(entity: String)
    }

    public enum NetworkError: Error {
        case error(statusCode: Int, data: Data?)
        case notConnected
        case cancelled
        case generic(Error)
        case urlGeneration
    }

    public enum DataTransferError: Error {
        case noResponse
        case parsing(Error)
        case networkFailure(NetworkError)
        case resolvedNetworkFailure(Error)
    }
}
