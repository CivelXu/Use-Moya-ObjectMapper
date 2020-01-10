//
//  NetworkRequest+Rx.swift
//  ReactorKitApp
//
//  Created by Civel Xu on 2019/12/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper

public extension TargetType {

    func requestObservableObject<T: Mappable>(
        nestedKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = nil) -> Observable<(T)> {
        return Observable.create { observer in
            let task = Network.default.provider.request(
                .target(self),
                callbackQueue: callbackQueue,
                progress: nil) { result in
                switch result {
                case let .success(response):
                    let contenxt = NestedMapContext(key: nestedKeyPath, mapArray: false)
                    guard let model = Mapper<NetworkResponse<T>>(context: contenxt).map(JSONObject: try? response.mapJSON()) else {
                        observer.onError(MoyaError.jsonMapping(response))
                        return
                    }
                    guard model.isSuccess else {
                        let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                        observer.onError(err)
                        return
                    }
                    guard let data = model.data else {
                        observer.onError(MoyaError.jsonMapping(response))
                        return
                    }
                    observer.onNext(data)
                    observer.onCompleted()
                case let .failure(err):
                    observer.onError(err)
                }
            }
            return Disposables.create(with: task.cancel)
        }
    }

    func requestObservableArray<T: Mappable>(
        nestedKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = nil) -> Observable<([T])> {
        return Observable.create { observer in
            let task = Network.default.provider.request(
                .target(self),
                callbackQueue: callbackQueue,
                progress: nil) { result in
                    switch result {
                    case let .success(response):
                        let contenxt = NestedMapContext(key: nestedKeyPath, mapArray: true)
                        guard let model = Mapper<NetworkResponse<T>>(context: contenxt).map(JSONObject: try? response.mapJSON()) else {
                            observer.onError(MoyaError.jsonMapping(response))
                            return
                        }
                        guard model.isSuccess else {
                            let err = NSError(domain: model.errorMsg, code: model.resultCode, userInfo: nil)
                            observer.onError(err)
                            return
                        }
                        guard let datas = model.datas else {
                            observer.onError(MoyaError.jsonMapping(response))
                            return
                        }
                        observer.onNext(datas)
                        observer.onCompleted()
                    case let .failure(err):
                        observer.onError(err)
                    }
            }
            return Disposables.create(with: task.cancel)
        }
    }

    /// Designated request-making method with progress.
    func requestWithProgress(callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        let progressBlock: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
            return { progress in
                observer.onNext(progress)
            }
        }
        let response: Observable<ProgressResponse> = Observable.create { observer in
            let cancellableToken = Network.default.provider.request(.target(self), callbackQueue: callbackQueue, progress: progressBlock(observer)) { result in
                switch result {
                case .success:
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                cancellableToken.cancel()
            }
        }
        // Accumulate all progress and combine them when the result comes
        return response.scan(ProgressResponse()) { last, progress in
            let progressObject = progress.progressObject ?? last.progressObject
            let response = progress.response ?? last.response
            return ProgressResponse(progress: progressObject, response: response)
        }
    }

}
