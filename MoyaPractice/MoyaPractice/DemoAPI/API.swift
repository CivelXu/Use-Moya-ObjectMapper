//
//  API.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/24.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya

let NetWorkBaseURLString = "https://iyuanben.com:30613"

enum API {
    case getNodeList
    case login(email: String, password: String)
    case getUserGroups(start: Int, page: Int, type: Int)
    case getNotifies
}

extension API: TargetType {

    var baseURL: URL {
        return URL(string: NetWorkBaseURLString)! // swiftlint:disable:this force_unwrapping
    }

    var path: String {
        switch self {
        case .getNodeList:
            return "/v1/discovers/services"
        case .login:
            return "/v1/account/email/login"
        case .getUserGroups:
            return "/v1/groups"
        case .getNotifies:
            return "/v2/notifies"
        }
    }

    var method: Method {
        switch self {
        case .getNodeList, .getUserGroups, .getNotifies:
            return .get
        case .login:
            return .post
        }
    }

    var sampleData: Data {
         return "response: test data".data(using: String.Encoding.utf8)! // swiftlint:disable:this force_unwrapping
    }

    var task: Task {

        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }

        switch self {
        case .getNodeList:
            return .requestPlain
        case .login(let email, let password):
            let parameters = ["email": email, "password": password]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getUserGroups(let start, let page, let type):
            let parameters = ["start": start, "page": page, "group_list_type": type, "page_size": 20]
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .getNotifies:
            let parameters = ["count": 1, "type_list": "0,1,2,3,4,5,6,7,8,9,10,11"] as [String: Any]
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
    }

    var headers: [String: String]? {
        return nil
    }

}
