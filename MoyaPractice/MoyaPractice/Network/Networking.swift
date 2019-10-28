//
//  Networking.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/23.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya
import ObjectMapper

let NetworkProvider = MoyaProvider<API>(
    endpointClosure: NetworkEndpointClosure,
    requestClosure: NetworkRequestClosure,
    plugins: MoyaPlugins(),
    trackInflights: false
)

@discardableResult
func NetworkRequestModel<T: Mappable>(
    _ target: API,
    atKeyPath: String = "",
    model: T.Type,
    callbackQueue: DispatchQueue? = .none,
    progressCallback: Moya.ProgressBlock? = nil,
    success: @escaping (_ data: T) -> Void,
    error: @escaping (_ error: Error) -> Void) -> Cancellable? {

    return NetworkProvider.request(
        target,
        callbackQueue: callbackQueue,
        progress: progressCallback) { result in
        switch result {
        case let .success(response):
            guard let model = Mapper<BaseResponse>(context: nil).map(JSONObject: try? response.mapJSON()) else {
                  error(MoyaError.jsonMapping(response))
                  return
            }
            guard model.isSuccess else {
                let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                error(err)
                return
            }
            let JSONObject: Any?
            if atKeyPath.isEmpty {
                JSONObject = model.data
            } else {
                JSONObject = (model.data as? NSDictionary)?.value(forKeyPath: atKeyPath)
            }
            guard let object = Mapper<T>(context: nil).map(JSONObject: JSONObject) else {
              error(MoyaError.jsonMapping(response))
              return
            }
            success(object)
        case let .failure(err):
            error(err)
        }
    }
}

@discardableResult
func NetworkRequestModels<T: Mappable>(
    _ target: API,
    atKeyPath: String = "",
    model: T.Type,
    callbackQueue: DispatchQueue? = .none,
    progressCallback: Moya.ProgressBlock? = nil,
    success: @escaping (_ data: [T]) -> Void,
    error: @escaping (_ error: Error) -> Void) -> Cancellable? {

    return NetworkProvider.request(
        target,
        callbackQueue: callbackQueue,
        progress: progressCallback) { result in
            switch result {
            case let .success(response):
                guard let model = Mapper<BaseResponse>(context: nil).map(JSONObject: try? response.mapJSON()) else {
                      error(MoyaError.jsonMapping(response))
                      return
                }
                guard model.isSuccess else {
                    let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                    error(err)
                    return
                }
                let JSONArray: [[String: Any]]?
                if atKeyPath.isEmpty {
                    JSONArray = model.data as? [[String: Any]]
                } else {
                    JSONArray = (model.data as? NSDictionary)?
                        .value(forKeyPath: atKeyPath) as? [[String: Any]]
                }
                guard let array = JSONArray else {
                    error(MoyaError.jsonMapping(response))
                    return
                }
                let objects = Mapper<T>(context: nil).mapArray(JSONArray: array)
                success(objects)
            case let .failure(err):
                error(err)
            }
    }
}

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
