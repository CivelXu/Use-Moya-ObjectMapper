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

//        NetworkRequestModel(
//            .getNodeList,
//            model: NodeModels.self,
//            success: { (model) in
//                let array = model.datas ?? []
//                array.forEach {
//                    print($0.miksName ?? "null miksName")
//                }
//        }) { (error) in
//            debugPrint(error.localizedDescription)
//        }

//        NetworkRequestModel(
//            .getNotifies,
//            atKeyPath: "separate_count",
//            model: TestNum.self,
//            success: { (model) in
//                print("$0.num ---- \(model.num)")
//        }) { (error) in
//            debugPrint(error.localizedDescription)
//        }

//        NetworkRequestModels(
//            .getNodeList,
//            atKeyPath: "datas",
//            model: NodeModel.self,
//            success: { (models) in
//                models.forEach {
//                    print($0.miksName ?? "null miksName")
//                }
//        }) { (error) in
//            debugPrint(error.localizedDescription)
//        }

//        NetworkRequestModel(
//            .login(email: "xuxiwen@yuanben.org", password: "xxw100294"),
//            model: UserModel.self,
//            success: { (model) in
//                debugPrint(model.email ?? "")
//                debugPrint(model.orgList?.first?.name ?? "")
//        }) { (error) in
//            debugPrint(error.localizedDescription)
//        }

        let now = NSDate()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval) * 1000 + 1000

        NetworkRequestModels(
            .getUserGroups(start: timeStamp, page: 0, type: 2),
            model: GroupModel.self,
            success: { groupModels in
                groupModels.forEach {
                    debugPrint($0.name ?? "")
                    debugPrint($0.creator?.name ?? "")
                }
        }) { (error) in
            debugPrint(error.localizedDescription)
        }

    }

}
