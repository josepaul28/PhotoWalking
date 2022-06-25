//
//  NetworkService.swift
//
//  Created by PAUL SOTO on 12/06/2020.
//  Copyright © 2020 PAUL SOTO. All rights reserved.
//

import Foundation

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, AppError.NetworkError>) -> Void

    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Implementation
final class DefaultNetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger

    init(config: NetworkConfigurable,
         sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
         logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }

    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let sessionDataTask = self.sessionManager.request(request) { data, response, requestErrorr in
            if let requestError = requestErrorr {
                var error: AppError.NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                if let response = response as? HTTPURLResponse {
                    guard (200...299).contains(response.statusCode) else {
                        return completion(.failure(.error(statusCode: response.statusCode, data: data)))
                    }

                    self.logger.log(responseData: data, response: response)
                    completion(.success(data))
                } else {
                    self.logger.log(responseData: data, response: response)
                    completion(.success(data))
                }
            }
        }
        self.logger.log(request: request)
        return sessionDataTask
    }

    private func resolve(error: Error) -> AppError.NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}

// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be incjected into NetworkService instead of default one.
class DefaultNetworkSessionManager: NetworkSessionManager {
    init() {}
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - Logger
final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody,
           let result = ((try? JSONSerialization.jsonObject(
                with: httpBody,
                options: []
           ) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: - NetworkError extension
extension AppError.NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }

    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}

