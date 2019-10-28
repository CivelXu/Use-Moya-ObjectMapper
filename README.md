# Pritice to use Moya and ObjectMapper

## 1. Set Custom API Info

```
enum API {
    case getNodeList
}

extension API: TargetType {

    var baseURL: URL {
        return URL(string: NetWorkBaseURLString)! // swiftlint:disable:this force_unwrapping
    }

    var path: String {
        switch self {
        case .getNodeList:
            return "/v1/discovers/services"
        }
    }

    var method: Method {
        switch self {
        case .getNodeList:
            return .get
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
        }
    }

    var headers: [String: String]? {
        return nil
    }

}

```

## 2. Configure BaseResponse

for example server base response
```
/*
{
  "data" :  Any,
  "result_code" : 600,
  "result_msg" : "success",
  "error_message" : null
}
*/

```

configure BaseResponse set for your server response

```
struct BaseResponse: Mappable {

    var data: Any?
    var resultCode: Int = 0
    var resultMsg: String = ""
    var errorMessage: String?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        data <- map["data"]
        errorMessage <- map["error_message"]
        resultCode <- map["result_code"]
        resultMsg <- map["result_msg"]
    }

}
```

## 3. Configure Mappable Models file

you can use [JSONEXport](https://github.com/Ahmed-Ali/JSONExport) auto create
```
import ObjectMapper

struct NodeModel: Mappable {

    var miksAbstract: String?
    var miksAvatar: String?
    var miksCreatedAt: Int?
    var miksDomain: String?
    var miksIp: String?
    var miksName: String?
    var miksUpdatedAt: Int?
    var nodeAddress: String?
    var update: Int?
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        miksAbstract <- map["miks_abstract"]
        miksAvatar <- map["miks_avatar"]
        miksCreatedAt <- map["miks_created_at"]
        miksDomain <- map["miks_domain"]
        miksIp <- map["miks_ip"]
        miksName <- map["miks_name"]
        miksUpdatedAt <- map["miks_updated_at"]
        nodeAddress <- map["node_address"]
        update <- map["update"]
    }

}

```

## 4. Send a request and bind Model Type

```
        NetworkRequestModels(
            .getNodeList,
            atKeyPath: "datas",
            model: NodeModel.self,
            success: { (models) in
                models.forEach {
                    print($0.miksName ?? "null miksName")
                }
        }) { (error) in
            debugPrint(error.localizedDescription)
        }
```

Implementation refer to [Networking.swift](https://github.com/CivelXu/Moya-ObjectMapper/blob/master/MoyaPractice/MoyaPractice/Network/Networking.swift)

