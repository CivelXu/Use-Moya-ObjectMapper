//
//  NetworkRequest+Single.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2020/1/10.
//  Copyright © 2020 Civel Xu. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper

public extension TargetType {

    func requestSingleObject<T: Mappable>(
        nestedKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = nil) -> Single<(T)> {
        return Single.create { single in
            let task = Network.default.provider.request(
                .target(self),
                callbackQueue: callbackQueue,
                progress: nil) { result in
                switch result {
                case let .success(response):
                    let contenxt = NestedMapContext(key: nestedKeyPath, mapArray: false)
                    guard let model = Mapper<NetworkResponse<T>>(context: contenxt).map(JSONObject: try? response.mapJSON()) else {
                        single(.error(MoyaError.jsonMapping(response)))
                        return
                    }
                    guard model.isSuccess else {
                        let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                        single(.error(err))
                        return
                    }
                    guard let data = model.data else {
                        single(.error(MoyaError.jsonMapping(response)))
                        return
                    }
                    single(.success(data))
                case let .failure(err):
                    single(.error(err))
                }
            }
            return Disposables.create(with: task.cancel)
        }
    }

    func requestSingleArray<T: Mappable>(
        nestedKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = nil) -> Single<([T])> {
        return Single.create { single in
            let task = Network.default.provider.request(
                .target(self),
                callbackQueue: callbackQueue,
                progress: nil) { result in
                    switch result {
                    case let .success(response):
                        let contenxt = NestedMapContext(key: nestedKeyPath, mapArray: true)
                        guard let model = Mapper<NetworkResponse<T>>(context: contenxt).map(JSONObject: try? response.mapJSON()) else {
                            single(.error(MoyaError.jsonMapping(response)))
                            return
                        }
                        guard model.isSuccess else {
                            let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                            single(.error(err))
                            return
                        }
                        guard let datas = model.datas else {
                            single(.error(MoyaError.jsonMapping(response)))
                            return
                        }
                        single(.success(datas))
                    case let .failure(err):
                        single(.error(err))
                    }
            }
            return Disposables.create(with: task.cancel)
        }
    }

}
