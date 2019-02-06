//
//  PostController.swift
//  WhyiOS
//
//  Created by Dominic Lanzillotta on 2/6/19.
//  Copyright © 2019 Dominic Lanzillotta. All rights reserved.
//

import Foundation

class PostController {
    
    //MARK: - BaseURL
    static var baseURL = URL(string:"https://whydidyouchooseios.firebaseio.com/reasons")
    
    
    
    //MARK: - Create
    static func postReason(name: String, reason:String, completion: @escaping (Bool) -> Void) {
        guard let fullUrl = baseURL?.appendingPathExtension("json") else {
            print("Could not unwrap baseURl")
            completion(false)
            return
        }
        
        let newReason = Post(name: name, cohort: "iOS 24", reason: reason)
        var postData: Data
        
        do {
            let encoder = JSONEncoder()
            postData = try encoder.encode(newReason)
        } catch  {
            print("Error encoding PostData: \(error) \(error.localizedDescription) ")
            completion(false)
            return
        }
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(false)
                print("Error has posting occured: \(error), \(error.localizedDescription)")
                return
            }
            guard data != nil else {
                print("Data could not be unwrapped")
                completion(false)
                return
            }
            completion(true)
        }
        dataTask.resume()
    }
    
    //MARK: - Read
    static func fetchPosts(completion: @escaping (Bool,[Post]) -> Void) {
        guard let fullUrl = baseURL?.appendingPathExtension("json") else {
            print("Could not unwrap baseURl")
            completion(false,[])
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: fullUrl) { (data, _, error) in
            if let error = error {
                completion(false,[])
                print("Error has loading has occured: \(error), \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Data could not be unwrapped")
                completion(false,[])
                return
            }
            do {
                let decoder = JSONDecoder()
                let postDictionary = try decoder.decode([String:Post].self, from: data)
                let posts = postDictionary.compactMap({ $0.value })
                completion(true,posts)
            } catch {
                completion(false,[])
                print("Date could not be decoded: \(error), \(error.localizedDescription)")
                return
            }
        }
        dataTask.resume()
    }
}
