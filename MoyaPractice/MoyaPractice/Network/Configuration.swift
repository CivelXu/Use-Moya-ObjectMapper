//
//  Configuration.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/11/8.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya

public struct Configuration {

    public struct Request {

        public static var `default`: Request = Request()

        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }

        public var replacingTask: (TargetType) -> Task = { $0.task }

        public var timeoutInterval: TimeInterval = 30

        public var plugins: [PluginType] = [NetworkLogPlugin]

        private init() {}
    }

    public struct Response {

        public static var `default`: Response = Response()

        public var successResultCode: Int = 600

        public var data: String = "data"

        public var resultCode: String = "result_code"

        public var resultMsg: String = "result_msg"

        public var errorMessage: String = "error_message"

        public var defaultErrorMessage: String = "An unknown error occurred"

        private init() {}

    }

}
