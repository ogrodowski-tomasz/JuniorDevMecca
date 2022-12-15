//
//  NetworkManager.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 15/12/2022.
//

import Foundation

enum NetworkingError: Error {
    case badResponse(statusCode: Int)
    case invalidUrl
    case noData
    case custom(Error)
    case decoding
}

protocol NetworkingManagerable {
    func call<T: Codable>(endpoint: Endpoint, decodeToType type: T.Type, completion: @escaping (Result<T, NetworkingError>) -> Void)
}

class NetworkingManager: NetworkingManagerable {
    func call<T>(endpoint: Endpoint, decodeToType type: T.Type, completion: @escaping (Result<T, NetworkingError>) -> Void) where T : Decodable, T : Encodable {
        guard let url = endpoint.url else {
            completion(.failure(.invalidUrl))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let urlSessionTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.custom(error!)))
                return
            }
            if let response = response as? HTTPURLResponse {
                guard (200...300) ~= response.statusCode else {
                    completion(.failure(.badResponse(statusCode: response.statusCode)))
                    return
                }
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(type.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decoding))
                }
            }
        }
        urlSessionTask.resume()
    }
    
    
}
