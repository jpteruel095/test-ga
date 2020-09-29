//
//  ArventaWeb+Endpoint.swift
//  Arventa Connect
//
//  Created by John Patrick Teruel on 9/23/20.
//

import Foundation
import Alamofire
import SwiftyJSON

extension ArventaWeb{
    // MARK: Endpoints
    enum Endpoint{
        case token
        case forgot
        var route: Route{
            switch self {
            case .token:
                return Route(path: "authservice/api/OAuth/v2/Token")
            case .forgot:
                return Route(path: "api/v1/clients/forgot")
            }
        }
    }
}

extension ArventaWeb{
    // MARK: Routes
    struct Route{
        let path: String
        var method: HTTPMethod? = nil
        var parameterEncoding: ParameterEncoding? = nil
        
        var url: URL{
            return URL(string: "\(ArventaWeb.Constants.host)\(self.path)")!
        }
    }

    enum LaravelMethod: String{
        typealias RawValue = String
        
        case patch = "patch"
        case put = "put"
        case delete = "delete"
    }
}

// MARK: Endpoints Extension
extension ArventaWeb.Endpoint{
    var isGuest: Bool{
        switch self{
        case .token:
            return true
        default:
            return false
        }
    }
    
    var httpMethod: HTTPMethod{
        switch self{
        case .token:
            return .post
        default:
            return route.method ?? .get
        }
    }
    
    var parameterEncoding: ParameterEncoding{
        if let encoding = route.parameterEncoding{
            return encoding
        }else{
            if httpMethod == .post{
                return JSONEncoding.default
            }else{
                return URLEncoding.default
            }
        }
    }
    
    /**
     Returns the headers for specific endpoints. If the endpoint is a guest endpoint and no token is saved,
     the header is null.
     */
    var headers: HTTPHeaders?{
        var headers = HTTPHeaders([
            HTTPHeader(name: "Accept", value: "application/json")
        ])
        
        if !self.isGuest{
//            if let current = User.current,
//                let accessToken = current.accessToken{
//                headers["Authorization"] = "Bearer \(accessToken)"
//            }else{
//                return nil
//            }
        }
        
        return headers
    }

    func addDictToFormData(_ formData: MultipartFormData, key: String, dictionary: [String: Any], shouldLog: Bool){
        for (dictKey, dictValue) in dictionary{
            let newKey = "\(key)[\(dictKey)]"
            if let itemArray = dictValue as? [Any] {
                addArrayToFormData(formData, key: newKey, array: itemArray, shouldLog: shouldLog)
            }else if let itemDict = dictValue as? [String: Any]{
                addDictToFormData(formData, key: newKey, dictionary: itemDict, shouldLog: shouldLog)
            }else{
                if let string = JSON(dictValue).rawString(),
                    let data = string.data(using: .utf8){
                    formData.append(data,
                                    withName: newKey)
                    if shouldLog {
                        print("\(newKey): \(string)")
                    }
                }
            }
        }
    }
    
    func addArrayToFormData(_ formData: MultipartFormData, key: String, array: [Any], shouldLog: Bool){
        for item in array {
            let newKey = "\(key)[]"
            if let itemArray = item as? [Any] {
                addArrayToFormData(formData, key: newKey, array: itemArray, shouldLog: shouldLog)
            }else if let itemDict = item as? [String: Any]{
                addDictToFormData(formData, key: newKey, dictionary: itemDict, shouldLog: shouldLog)
            }else{
                if let string = JSON(item).rawString(),
                    let data = string.data(using: .utf8){
                    formData.append(data,
                                    withName: newKey)
                    if shouldLog {
                        print("\(newKey): \(string)")
                    }
                }
            }
        }
    }
    
    /**
     Calls the request for the specified Endpoint
     - parameters:
        - parameters: The parameters for the request.
        - progressCallback: Callback that returns the progress of the current request.
        - completion: Callback for the response of the request.
        - shouldLog: Specified to allow the current requet log before request and response.
        - shouldLogResult: If request is allowed to log, user can choose to not log the result.
     */
    func upload(parameters: Parameters? = nil,
                 progressCallback:((Progress) -> Void)? = nil,
                 completion:((JSON?, Error?) -> Void)? = nil,
                 shouldLog: Bool = true,
                 shouldLogRequest: Bool = true,
                 shouldLogResult: Bool = true)
    {
        //Check for headers available for the route
        //If the current request is a guest,
        // the header is not null
        guard let headers = headers else {
            if let completion = completion{
                completion(nil, Helpers.makeError(with: "Unauthorized access. Token may have expired."))
                //must implement a force logout functionality here
            }
            return
        }
        
        //The developer can choose to log the request
        // or not.
        if shouldLog && shouldLogRequest{
            print("Request URL: \(route.url.absoluteString)")
            print("Header: \(headers.dictionary.toJSONString())")
            print("Method: \(httpMethod.rawValue)")
            if let parameters = parameters{
                print("Parameters: \(parameters.toJSONString())")
            }
        }
        
        //Starts executing the request in hear
        let _ = AF.upload(multipartFormData: { (formData) in
            // import parameters
            if let parameters = parameters{
                print("Added to form data:")
                for (key, value) in parameters {
                    if let array = value as? [Any]{
                        self.addArrayToFormData(formData,
                                                key: key,
                                                array: array,
                                                shouldLog: shouldLog)
                    }else if let dict = value as? [String: Any]{
                        self.addDictToFormData(formData,
                                               key: key,
                                               dictionary: dict,
                                               shouldLog: shouldLog)
                    }else{
                        if let value = JSON(value).rawString(),
                            let data = value.data(using: .utf8){
                            formData.append(data, withName: key)
                            if shouldLog && shouldLogRequest {
                                print("\(key): \(value)")
                            }
                        }
                    }
                }
            }
        }, to: route.url,
           method: httpMethod,
           headers: headers).uploadProgress(closure: { (progress) in
            print("progress: \(progress.fractionCompleted)")
            if let progressCallback = progressCallback{
                DispatchQueue.main.async {
                    progressCallback(progress)
                }
            }
           }).responseJSON { (response) in
            self.handleResponseJSON(parameters: parameters,
                                    progressCallback: progressCallback,
                                    completion: completion,
                                    shouldLog: shouldLog,
                                    shouldLogRequest: shouldLogRequest,
                                    shouldLogResult: shouldLogResult,
                                    response: response)
        }
    }

    /**
     Calls the request for the specified Endpoint
     - parameters:
        - parameters: The parameters for the request.
        - progressCallback: Callback that returns the progress of the current request.
        - completion: Callback for the response of the request.
        - shouldLog: Specified to allow the current requet log before request and response.
        - shouldLogResult: If request is allowed to log, user can choose to not log the result.
     */
    func request(parameters: Parameters? = nil,
                 progressCallback:((Progress) -> Void)? = nil,
                 completion:((JSON?, Error?) -> Void)? = nil,
                 shouldLog: Bool = true,
                 shouldLogRequest: Bool = true,
                 shouldLogResult: Bool = true)
    {
        //Check for headers available for the route
        //If the current request is a guest,
        // the header is not null
        guard let headers = headers else {
            if let completion = completion{
                completion(nil, Helpers.makeError(with: "Unauthorized access. Token may have expired."))
                //must implement a force logout functionality here
            }
            return
        }
        
        var parameters = parameters
        var method: HTTPMethod = httpMethod
        
        //The developer can choose to log the request
        // or not.
        if shouldLog && shouldLogRequest{
            print("Request URL: \(route.url.absoluteString)")
            print("Header: \(headers.dictionary.toJSONString())")
            print("Method: \(httpMethod.rawValue)")
            if let parameters = parameters{
                print("Parameters: \(parameters.toJSONString())")
            }
        }
        
        //Starts executing the request in hear
        AF.request(route.url,
                method: method,
                parameters: parameters,
                encoding: parameterEncoding,
                headers: headers).downloadProgress(closure: { (progress) in
                //If the developer provided a callback for progress,
                // the callback will be called through here
                if let progressCallback = progressCallback{
                    print("progress: \(progress.fractionCompleted)")
                    DispatchQueue.main.async {
                        progressCallback(progress)
                    }
                }
        }).responseJSON(completionHandler: { (response) in
            self.handleResponseJSON(parameters: parameters,
                                    progressCallback: progressCallback,
                                    completion: completion,
                                    shouldLog: shouldLog,
                                    shouldLogRequest: shouldLogRequest,
                                    shouldLogResult: shouldLogResult,
                                    response: response)
        })
    }
    
    fileprivate func handleResponseJSON(parameters: Parameters? = nil,
                            progressCallback:((Progress) -> Void)? = nil,
                            completion:((JSON?, Error?) -> Void)? = nil,
                            shouldLog: Bool = true,
                            shouldLogRequest: Bool = true,
                            shouldLogResult: Bool = true,
                            response: DataResponse<Any, AFError>)
    {
        //The developer can choose to log the result specifically.
        // If the logging of request was disabled by default,
        // The result will not be logged either.
        if shouldLog && shouldLogResult{
            print("Response for URL: \(self.route.url.absoluteString)")
            print(response)
        }
        
        DispatchQueue.main.async {
            //error is not being thrown if the token is not expired from the backend
            //so better handle it in this block
            if let statusCode = response.response?.statusCode,
                    statusCode != 200{
                print("Status \(statusCode)")
                print(response)
                if statusCode == 404{
                    
                    return
                }
                else if statusCode == 401{
                    if !self.isGuest{
                        
                    }else{
                        
                    }
                    return
                }
                else if statusCode == 403{
                    
                }
                else if statusCode == 500{
                    
                }
            }
            
            switch response.result{
            case .success(let json):
                let json = JSON(json)
                completion?(json, nil)
                break
            case .failure(let error):
                print("An error occured while attempting to process the request")
                print(error.localizedDescription)
                print(error)
                if (error as NSError).code == 13{
                    completion?(nil, Helpers.makeOfflineError())
                }else{
                    completion?(nil, error)
                }
            }
        }
    }
}
