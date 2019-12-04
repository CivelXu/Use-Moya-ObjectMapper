//
//  NetworkLoggerPlugin.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/11/8.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya

public let NetworkLogPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)

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
