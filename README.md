# How to use ?

## 1. Set common configuration if you need

/// Configure plugins
```
Configuration.Request.default.plugins = [NetworkLogPlugin]
```

        
/// Configure timeoutInterval
```
Configuration.Request.default.timeoutInterval = 60
```

/// Configure common parameters etc.
```
Configuration.Request.default.replacingTask = { target in
            switch target.task {
            case let .requestParameters(parameters, encoding):
                return .requestParameters(parameters: parameters, encoding: encoding)
            default:
                return target.task
            }
        }
```
     
/// Configure common headers etc.
```
Configuration.Request.default.addingHeaders = { _ in
            return ["SessionKey": "",
                    "OrgID": ""]
}
```

## 2. Set your custom API by Moya style

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

## 3. set your server response configuration

For example your server base response
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
You can configure like this

```
Configuration.Response.default.data = "data"
Configuration.Response.default.resultCode = "result_code"
Configuration.Response.default.resultMsg = "result_msg"
Configuration.Response.default.errorMessage = "error_message"
Configuration.Response.default.successResultCode = 600
```
## 4. Create your Swift object（Mappable） file

you can use [JSONEXport](https://github.com/Ahmed-Ali/JSONExport) auto convert by JSON
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
## 5. Send a request and bind model（Mappable） type

### Request function

- request Object
```API(Target).requestObject....```

- request Array Object
```API(Target).requestArray...```

Tip: 
you can use nestedKeyPath mapping of Nested Objects, refer to [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper#easy-mapping-of-nested-objects) feature，
But you need ingnore the prefix NetworkResponse data( "data.") key.

Send Request like this ...

```
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
```

Also We have RxSwift Version
```
            API.getMembers(page: 0)
                .requestArray(model: Member.self)
                .subscribe(onNext: { members in
                    
                }, onError: { error in
                    
                }
            )
```

Implementation refer to [NetworkRequest.swift](https://github.com/CivelXu/Use-Moya-ObjectMapper/blob/master/MoyaPractice/MoyaPractice/Network/NetworkRequest.swift)

