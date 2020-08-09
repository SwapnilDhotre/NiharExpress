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
    case ambiguous = ""
    
    var message: String {
        switch self {
        case .success:
            return "Api Success"
        case .alreadyExist:
            return "Data already exist"
        case .badRequest:
            return "Something went wrong"
        case .unauthorizedAccess:
            return "User login expired"
        case .notFound:
            return "Not found"
        case .methodNotFound:
            return "URL error"
        case .ambiguous:
            return "Something went wrong"
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
            if let param = parameters {
                var urlComponents = URLComponents(string: urlString)!
                var urlItems: [URLQueryItem] = []
                for (key, value) in param {
                    urlItems.append(URLQueryItem(name: key, value: value))
                }
                urlComponents.queryItems = urlItems
                
                request.url = urlComponents.url
            }
            
            print("URL Request hit:>> \(request.url)")
            self.executeRequest(urlRequest: request, completionHandler: completionHandler)
            
        case .post, .put, .delete:
            let boundary = self.generateBoundary()
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: Constants.headers.contentType)
            
            let dataBody = self.createDataBody(withParameters: parameters, boundary: boundary)
            request.httpBody = dataBody
            self.executeRequest(urlRequest: request, completionHandler: completionHandler)
        }
    }
    
    private func executeRequest(urlRequest: URLRequest, completionHandler: @escaping APICallCompletionHandler) {
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
                completion(nil, apiStatus)
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
