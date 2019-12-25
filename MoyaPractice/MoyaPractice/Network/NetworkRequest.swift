//
//  Networking.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/23.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya
import ObjectMapper

struct NestedMapContext: MapContext {
    var key = ""
    var mapArray: Bool
}

public extension TargetType {

    @discardableResult
    func requestObject<T: Mappable>(
        nestedKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = .none,
        progressCallback: Moya.ProgressBlock? = nil,
        success: @escaping (_ data: T) -> Void,
        error: @escaping (_ error: Error) -> Void) -> Cancellable? {

        return Network.default.provider.request(
            .target(self),
            callbackQueue: callbackQueue,
            progress: progressCallback) { result in
            switch result {
            case let .success(response):
                DispatchQueue.global().async {
                    let contenxt = NestedMapContext(key: nestedKeyPath, mapArray: false)
                    guard let model = Mapper<NetworkResponse<T>>(context: contenxt).map(JSONObject: try? response.mapJSON()) else {
                        DispatchQueue.main.async { error(MoyaError.jsonMapping(response)) }
                          return
                    }
                    guard model.isSuccess else {
                        let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                        DispatchQueue.main.async { error(err) }
                        return
                    }
                    guard let data = model.data else {
                        DispatchQueue.main.async { error(MoyaError.jsonMapping(response)) }
                        return
                    }
                    DispatchQueue.main.async { success(data) }
                }
            case let .failure(err):
                error(err)
            }
        }
    }

    @discardableResult
    func requestArray<T: Mappable>(
        nestedKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = .none,
        progressCallback: Moya.ProgressBlock? = nil,
        success: @escaping (_ data: [T]) -> Void,
        error: @escaping (_ error: Error) -> Void) -> Cancellable? {

        return Network.default.provider.request(
            .target(self),
            callbackQueue: callbackQueue,
            progress: progressCallback) { result in
                switch result {
                case let .success(response):
                    DispatchQueue.global().async {
                        let contenxt = NestedMapContext(key: nestedKeyPath, mapArray: true)
                        guard let model = Mapper<NetworkResponse<T>>(context: contenxt).map(JSONObject: try? response.mapJSON()) else {
                            DispatchQueue.main.async { error(MoyaError.jsonMapping(response)) }
                              return
                        }
                        guard model.isSuccess else {
                            let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                            DispatchQueue.main.async { error(err) }
                            return
                        }
                        guard let datas = model.datas else {
                            DispatchQueue.main.async { error(MoyaError.jsonMapping(response)) }
                            return
                        }
                        DispatchQueue.main.async { success(datas) }
                    }
                case let .failure(err):
                    error(err)
                }
        }
    }

}
