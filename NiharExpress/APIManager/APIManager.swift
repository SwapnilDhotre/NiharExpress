//
//  APIManager.swift
//  Saint Food
//
//  Created by Swapnil_Dhotre on 6/14/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIStatus: String {
    case success = "200"
    case alreadyExist = "304"
    case badRequest = "400"
    case unauthorizedAccess = "401"
    case notFound = "404"
    case methodNotFound = "405"
    case invalidUserToRedeemCode = "600"
    case orderNotAllowedInSelectedCity = "702"
    case ambiguous = ""
    case noMsg = "noMsg"
    
    var message: String {
        switch self {
        case .success:
            return "Api Success" // 200
        case .alreadyExist:
            return "User already exist" // 304
        case .badRequest:
            return "Something went wrong" // 400
        case .unauthorizedAccess:
            return "User login expired" // 401
        case .notFound:
            return "Not found" // 404
        case .methodNotFound:
            return "URL error" // 405
        case .ambiguous:
            return "Something went wrong"
        case .invalidUserToRedeemCode:
            return "Invalid user to redeem code" // 600
        case .noMsg:
            return "";
        case .orderNotAllowedInSelectedCity:
            return "Order not allowed in selected city"
        }
    }
}

typealias Parameters = [String: String?]
typealias Headers = [String: String]
typealias APICallCompletionHandler = (_ response: [String:Any]?, _ error: Error?) -> Void

class APIManager {
    
    static var shared = APIManager()
    
    private let session = URLSession.shared
    
    private init() { }
    
    static func headers() -> Headers {
        if UserConstant.shared.token != "" {
            let headers: Headers = [
                Constants.headers.accept: "application/json",
                Constants.headers.authorization: "\(Constants.headers.bearer) \(UserConstant.shared.token)"
            ]
            return headers
        }
        
        return [:]
    }
    
    func executeDataRequest(urlString: String, method: HttpMethod, parameters: Parameters?, headers: Headers?, completionHandler: @escaping APICallCompletionHandler) {
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        
        if let httpHeaders = headers {
            request.allHTTPHeaderFields = httpHeaders
        } else {
            request.addValue("application/json", forHTTPHeaderField: Constants.headers.accept)
        }
        
        request.httpMethod = method.rawValue
        
        switch method {
        case .get:
            if var param = parameters {
                param["device"] = "A"
                
                var urlComponents = URLComponents(string: urlString)!
                var urlItems: [URLQueryItem] = []
                for (key, value) in param {
                    urlItems.append(URLQueryItem(name: key, value: value))
                }
                urlComponents.queryItems = urlItems
                
                request.url = urlComponents.url
            }
            
            print("URL Request hit:>> \(String(describing: request.url?.absoluteString))")
            self.executeRequest(urlRequest: request, completionHandler: completionHandler)
            
        case .post, .put, .delete:
            do{
                let data = try JSONSerialization.data(withJSONObject: parameters!, options: [])
                let jsonString = String.init(data: data, encoding: .utf8)
                let url = ["data": jsonString]
                let data1 = try JSONSerialization.data(withJSONObject: url, options: [])
                request.httpBody =  data1
                self.executeRequest(urlRequest: request, completionHandler: completionHandler)
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func executeRequest(urlRequest: URLRequest, completionHandler: @escaping APICallCompletionHandler) {
        self.session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error:>> \(error)")
                completionHandler(nil, error)
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    completionHandler(json, nil)
                } catch {
                    print("Parsing data error: \(error.localizedDescription)")
                    completionHandler(nil, error)
                }
            }
        }.resume()
    }
    
    private func createJsonString(parameter dict: [String:Any]) -> String {
        
        if JSONSerialization.isValidJSONObject(dict) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
                
                var safeCharacterSet = NSCharacterSet.urlQueryAllowed
                safeCharacterSet.remove(charactersIn: "&=")
                safeCharacterSet.remove(charactersIn: "+=")
                
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)?.addingPercentEncoding(withAllowedCharacters: safeCharacterSet) {
                    return jsonString as String
                }
            } catch let JSONError as NSError {
                print("\(JSONError)")
            }
        }
        return ""
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func createDataBody(withParameters params: Parameters?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = String()
        
        if let parameters = params {
            for (key, value) in parameters {
                body += "--\(boundary + lineBreak)"
                body += "Content-Disposition:form-data; name=\"\(key)\"\(lineBreak + lineBreak)"
                body += "\(value)\(lineBreak)"
            }
        }
        body += "--\(boundary)--\(lineBreak)"
        
        return body.data(using: .utf8)!
    }
    
    func parseResponse(responseData: [String: Any]?, completion: ([[String: Any]]?, APIStatus?) -> Void) {
        if let data = responseData {
            if let data = data[keyPath: "\(Constants.Response.response).\(Constants.Response.data)"] as? [[String: Any]] {
                completion(data, nil)
            } else if let data = data[keyPath: "\(Constants.Response.response).\(Constants.Response.data)"] as? [String: Any] {
                completion([data], nil)
            } else if let value = data[keyPath: "\(Constants.Response.response).\(Constants.Response.data)"] as? String {
                completion([["value": value]], nil)
            } else if let status = data[keyPath: "\(Constants.Response.response).\(Constants.Response.responseCode)"] as? String, let apiStatus = APIStatus(rawValue: status) {
                if apiStatus == .notFound {
                    completion(nil, .noMsg)
                } else {
                    completion(nil, apiStatus)
                }
            } else if let status = data[keyPath: "\(Constants.Response.response).\(Constants.Response.code)"] as? String, let apiStatus = APIStatus(rawValue: status) {
                completion(nil, apiStatus)
            } else {
                completion(nil, APIStatus.ambiguous)
            }
        } else {
            completion(nil, nil)
        }
    }
}
