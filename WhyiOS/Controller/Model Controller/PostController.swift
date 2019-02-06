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
