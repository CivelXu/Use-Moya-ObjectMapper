//
//  APIProvider.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/28.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya

let NetworkTimeOut: Double = 30
let NetworkSuccessCode: Int = 600
let NetworkEmptyError: String =  "An unknown error occurred"
let NetWorkBaseURLString = "https://iyuanben.com:30613"

/// MoyaProvider
let NetworkProvider = MoyaProvider<API>(
    endpointClosure: NetworkEndpointClosure,
    requestClosure: NetworkRequestClosure,
    plugins: MoyaPlugins(),
    trackInflights: false
)

/// Endpoint
private let NetworkEndpointClosure = { (target: API) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    return endpoint
}

/// RequestResultClosure
private let NetworkRequestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = NetworkTimeOut
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/// NetworkActivityPlugin
private let NetworkPlugin = NetworkActivityPlugin { (changeType, _) in
    // current targetType
    switch(changeType) {
    case .began:
        print("开始请求网络")
    case .ended:
        print("结束")
    }
}

private func MoyaPlugins() -> [PluginType] {
    var plugins = [PluginType]()
    #if DEBUG
    plugins.append(myLoggorPlugin)
    #else
    #endif
    return plugins
}

/// NetworkLoggerPlugin
private let myLoggorPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        // fallback to original data if it can't be serialized.
        return data
    }
}
