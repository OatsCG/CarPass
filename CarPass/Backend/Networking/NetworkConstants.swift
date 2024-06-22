//
//  Constants.swift
//  CarPass
//
//  Created by Charlie Giannis on 2024-06-18.
//

import Foundation


var GLOBAL_SERVER: String = "https://carpasscdn.openmusic.app/carpassapi/"

func serverEndpoint(_ endpoint: String) -> String {
    return(GLOBAL_SERVER + endpoint)
}

func fetchServerEndpoint<T: Decodable>(endpoint: String, fetchHash: UUID, decodeAs: T.Type, completion: @escaping (Result<T, Error>, UUID) -> Void) {
    let url = serverEndpoint(endpoint)
    
    guard let url = URL(string: url) else {
        print("Invalid endpoint \(endpoint)")
        completion(.failure(URLError(.badURL)), fetchHash)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error), fetchHash)
        } else if let data = data {
            let decoder = JSONDecoder()
            do {
                let fetchedData = try decoder.decode(decodeAs, from: data)
                completion(.success(fetchedData), fetchHash)
            } catch {
                completion(.failure(error), fetchHash)
            }
        }
    }
    task.resume()
}
