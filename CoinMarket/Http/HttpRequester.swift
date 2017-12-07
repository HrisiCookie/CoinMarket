//
//  HttpRequester.swift
//  PersonalFinance
//
//  Created by Cookie on 14.10.17.
//  Copyright © 2017 Cookie. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

class HttpRequester {
    var delegate : HttpRequesterDelegate?
    
    func get(from url: String) {
        makeRequest(to: url, with: .get, andBody: nil)
    }
    
    func makeRequest(to urlString: String, with httpMethod: HttpMethod, andBody body: Data? ) {
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            handleError(forHttpMethod: httpMethod, with: "Could not construct URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.log(title: "REQUEST", with: response ?? "")
            guard error == nil else {
                if let errMsg = error?.localizedDescription {
                    self.handleError(forHttpMethod: httpMethod, with: errMsg)
                }
                
                return
            }
            
            guard let httpResponse = response as! HTTPURLResponse? else {
                self.handleError(forHttpMethod: httpMethod, with: "Invalid response")
                return
            }
            
            switch(httpResponse.statusCode) {
            case 200...399:
                guard let responseData = data else {
                    self.handleError(forHttpMethod: httpMethod, with: "No data in response")
                    return
                }
                self.handleSuccess(forHttpMethod: httpMethod, with: responseData)
                do {
                    let dict = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                    self.log(title: "RESPONSE", with: dict)
                } catch {
                    
                }
            default:
                guard let responseError = data else {
                    self.handleError(forHttpMethod: httpMethod, with: "Error cannot be parsed")
                    return
                }
                
                let err = try? JSONSerialization.jsonObject(with: responseError, options: .allowFragments)
                self.handleError(forHttpMethod: httpMethod, with: String(describing: err))
                self.log(title: "ERROR", with: String(describing: err))
            }
        }
        
        dataTask.resume()
    }
    
    func handleError(forHttpMethod httpMethod: HttpMethod, with error: String) {
        switch httpMethod {
        case .get:
            delegate?.didGetFailed(with: error)
        }
    }
    
    func handleSuccess(forHttpMethod httpMethod: HttpMethod, with data: Data) {
        switch httpMethod {
        case .get:
            delegate?.didGetSuccess(with: data)
        }
    }
    
    private func log(title: String, with: Any) {
        print("""
            ---------------------------------------------------------------------------
            --------------------------------- \(title) --------------------------------
            ---------------------------------------------------------------------------
            
            \(with)
            
            ---------------------------------------------------------------------------
            ---------------------------------------------------------------------------
            """)
    }
}

protocol HttpRequesterDelegate {
    func didGetSuccess(with data: Data)
    func didGetFailed(with error: String)
}
