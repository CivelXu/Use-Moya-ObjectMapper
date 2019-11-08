//
//  ViewController.swift
//  MoyaPractice
//
//  Created by Civel Xu on 2019/10/23.
//  Copyright © 2019 Civel Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        #if DEBUG
        Configuration.Request.default.plugins = [NetworkLogPlugin]
        #else
        #endif

        Configuration.Request.default.timeoutInterval = 60

        // Configure common parameters etc.
        Configuration.Request.default.replacingTask = { target in
            switch target.task {
            case let .requestParameters(parameters, encoding):
                return .requestParameters(parameters: parameters, encoding: encoding)
            default:
                return target.task
            }
        }

        // Configure common headers etc.
        Configuration.Request.default.addingHeaders = { _ in
            return ["SessionKey": "1e0c9920de3b168ece58f298af6740e7aa609a7b493f223c5d991c0da1c0ad83",
                    "OrgID": "e9ed44003980bf0cf7c73a354af9f3870890a388f3aaad7c76d0e5d74fcb3540"]
        }

        Configuration.Response.default.data = "data"
        Configuration.Response.default.resultCode = "result_code"
        Configuration.Response.default.resultMsg = "result_msg"
        Configuration.Response.default.errorMessage = "error_message"
        Configuration.Response.default.successResultCode = 600

        login()
        getNodeList()
        getNodeList2()
        getNotifies()
        getUserGroups()

    }

}

extension ViewController {
    private func login() {
        API.login(email: "xuxiwen@yuanben.org", password: "xxw100294")
            .requestObject(
            model: UserModel.self,
            success: { (model) in
                debugPrint(model.email ?? "")
                debugPrint(model.orgList?.first?.name ?? "")
        }) { (error) in
            debugPrint(error.localizedDescription)
        }
    }

    private func getNodeList() {
        API.getNodeList.requestObject(
            model: NodeModels.self,
            success: { (model) in
            let array = model.datas ?? []
            array.forEach {
                print($0.miksName ?? "null miksName")
            }
        }) { (error) in
            debugPrint(error.localizedDescription)
        }
    }

    private func getNodeList2() {
        API.getNodeList.requestArray(
            nestedKeyPath: "datas",
            model: NodeModel.self,
            success: { (models) in
                models.forEach {
                    print($0.miksName ?? "null miksName")
                }
        }) { (error) in
            debugPrint(error.localizedDescription)
        }
    }

    private func getNotifies() {
        API.getNotifies.requestObject(
            nestedKeyPath: "separate_count",
            model: TestNum.self,
            success: { (model) in
                print("$0.num ---- \(model.num)")
        }) { (error) in
            debugPrint(error.localizedDescription)
        }
    }

    private func getUserGroups() {
        let now = NSDate()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval) * 1000 + 1000

        API.getUserGroups(start: timeStamp, page: 0, type: 2).requestArray(
            model: GroupModel.self,
            success: { (groupModels) in
                groupModels.forEach {
                    debugPrint($0.name ?? "")
                    debugPrint($0.creator?.name ?? "")
                }
        }) { (error) in
            debugPrint(error.localizedDescription)
        }
    }
}
