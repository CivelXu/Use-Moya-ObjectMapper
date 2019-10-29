//
//  Networking.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/23.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya
import ObjectMapper

extension MoyaProvider {

    @discardableResult
    func requestObject<T: Mappable>(
        _ target: Target,
        atKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = .none,
        progressCallback: Moya.ProgressBlock? = nil,
        success: @escaping (_ data: T) -> Void,
        error: @escaping (_ error: Error) -> Void) -> Cancellable? {

        return request(
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
    func requestArray<T: Mappable>(
        _ target: Target,
        atKeyPath: String = "",
        model: T.Type,
        callbackQueue: DispatchQueue? = .none,
        progressCallback: Moya.ProgressBlock? = nil,
        success: @escaping (_ data: [T]) -> Void,
        error: @escaping (_ error: Error) -> Void) -> Cancellable? {

        return request(
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

}
