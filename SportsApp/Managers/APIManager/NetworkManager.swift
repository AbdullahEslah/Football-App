//
//  NetworkManager.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 15/10/2022.
//

import Foundation

class NetworkManager {
    
    //  Access Singelton through shared object
    static var shared = NetworkManager()
    
    //  Constructor
    private init() {
        
    }
    
    
   
    //  Generic Get Request
    func taskForGETRequest<ResponseType:Decodable, ErrorType:Decodable>(url:URL,completion: @escaping (ResponseType?,ErrorType?, Error?) -> Void ){
        var request = URLRequest(url: url)
         request.setValue("769731439adf4a96b6ed69c2b586f745", forHTTPHeaderField: "X-Auth-Token")
         request.setValue("application/json", forHTTPHeaderField:"Content-Type")
         request.httpMethod = "GET"
        
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
//            if let _ = error {
//                completion(nil,error)
//                return
//            }
             guard let data = data else {return}
            
             guard let response = response as? HTTPURLResponse else {return}
             switch response.statusCode   {
                 
             case 400..<500:
                //Helper.displayMessage(message: "Not Available", messageError: <#T##Bool#>)
                do {
                    let jsonError = try JSONDecoder().decode(ErrorType.self, from: data)
                    completion(nil, jsonError, nil)
                } catch let jsonError {
                    print(jsonError)
                }
             default:
                 
                completion(nil,nil,error)
//                return
            }
            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(nil, error)
//                }
//                return
//            }
             
             // Success
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil,nil)
                }
            } catch let jsonError {
                DispatchQueue.main.async {
                    //completion(nil, error)
                    print(jsonError)
                }
            }
        }
        task.resume()
        
    }
}
