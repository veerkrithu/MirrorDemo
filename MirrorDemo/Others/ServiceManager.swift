//
//  ServiceManager.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 6/30/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  Service Manager class will take care of restful service calls with backend server. It triggers the web service calls asynchronously and post the results through completion handler / closures
import Foundation

typealias CompletionHandler = (_ data: Data?, _ error: Error?)->Void

class ServiceManager {
    
    let appUrl: String
    let httpEndPoint: String
    let httpMethod: String
    
    init(withAppUrl appUrl: String, httpEndPoint endpoint: String, httpMethod method: String) {
        
        self.appUrl = appUrl
        self.httpEndPoint = endpoint
        self.httpMethod = method
    }
    
    //Send request asynchronously with header and body if exists and post the results through completion handler / closures
    func sendRequest(withBody body:[String: Any]?, theHeader header:[String: String]?, andCompletionHandler handler: @escaping CompletionHandler)
    {
        if let request = self.prepareRequest(withBody: body, andHeader: header) {
            
            URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                
                if (response as? HTTPURLResponse) != nil {
                    
                    if let httpData = data {
                        handler(httpData, nil)
                    }
                    
                }
                else {
                    
                    handler(nil, self?.errorForMessage(message: "Invalid Response"))
                }
                
            }).resume()
        }
        else {
            
            handler(nil, self.errorForMessage(message: "Invalid Request"))
        }
    }
    
    //Prepare and returns the url request object based on end point, app url, header data, body data and http method
    private func prepareRequest(withBody body: [String: Any]?, andHeader header: [String: String]?)->(URLRequest?) {
       
        let endPointUrl = self.appUrl + self.httpEndPoint
        
        var urlRequest = URLRequest(url: URL(string: endPointUrl)!)
        urlRequest.httpMethod = self.httpMethod
        
        if let httpBody = body {
            
            guard let data = try? JSONSerialization.data(withJSONObject: httpBody, options: []) else { return nil}
            urlRequest.httpBody = data
        }
        
        if let httpHeader = header {
            
            for (key, value) in httpHeader {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return urlRequest
    }
    
    //Method to return error object based on given error message
    private func errorForMessage(message: String)->Error {
        
        return NSError(domain: "com.Self.MirrorDemo", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

