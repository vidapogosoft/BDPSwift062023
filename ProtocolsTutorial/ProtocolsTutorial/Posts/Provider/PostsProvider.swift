//
//  PostsProvider.swift
//  ProtocolsTest
//
//  Created by Victor Roldan on 4/09/21.
//

import Foundation

protocol PostsProviderProtocol {
    func getPosts(_ completion: @escaping (Result<([PostModel], URLResponse?), Error>) -> Void)
}

class PostsProvider : PostsProviderProtocol{
    func getPosts(_ completion: @escaping (Result<([PostModel], URLResponse?), Error>) -> Void) {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
              completion(.failure(error))
            } else if let data = data, let response = response {
                do {
                    let res = try JSONDecoder().decode([PostModel].self, from: data)
                    //sleep(1)
                    completion(.success((res, response)))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
class PostsProviderMock : PostsProviderProtocol{
    func getPosts(_ completion: @escaping (Result<([PostModel], URLResponse?), Error>) -> Void) {
        let url = Bundle.main.url(forResource: "PostsMock", withExtension: "json")
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let jsonData = try Data(contentsOf: url!)
            let model = try decoder.decode([PostModel].self, from: jsonData)
            completion(.success((model, nil)))
        }catch let error{
            completion(.failure(error))
        }
        
    }
}
