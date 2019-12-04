//
//  APIProvider.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/28.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya

public class Network {

    public static let `default`: Network = {
        Network(configuration: Configuration.Request.default)
    }()

    public let provider: MoyaProvider<MultiTarget>

    public init(configuration: Configuration.Request) {
        provider = MoyaProvider(configuration: configuration)
    }

}

public extension MoyaProvider {

    convenience init(configuration: Configuration.Request) {

        let endpointClosure = { target -> Endpoint in
            MoyaProvider.defaultEndpointMapping(for: target)
                .adding(newHTTPHeaderFields: configuration.addingHeaders(target))
                .replacing(task: configuration.replacingTask(target))
        }

        let requestClosure = { (endpoint: Endpoint, closure: RequestResultClosure) -> Void in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = configuration.timeoutInterval
                closure(.success(request))
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(.parameterEncoding(error)))
            } catch {
                closure(.failure(.underlying(error, nil)))
            }
        }

        self.init(endpointClosure: endpointClosure,
                  requestClosure: requestClosure,
                  plugins: configuration.plugins)
    }
}
