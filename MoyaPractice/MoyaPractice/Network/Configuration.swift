//
//  Configuration.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/11/8.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import Moya

public extension Network {

    struct Configuration {

        public static var `default`: Configuration = Configuration()

        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }

        public var replacingTask: (TargetType) -> Task = { $0.task }

        public var timeoutInterval: TimeInterval = 30

        public var plugins: [PluginType] = []

        public init() {}
    }

}

extension NetworkResponse {

    struct Configuration {

        public static var `default`: Configuration = Configuration()

        public var successResultCode: Int = 600

        public var data: String = "data"

        public var resultCode: String = "result_code"

        public var resultMsg: String = "result_msg"

        public var errorMessage: String = "error_message"

        public var defaultErrorMessage: String = "An unknown error occurred"

        public init() {}
    }

}
