//
//  TDTagSearchInteractor.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import Foundation

import Foundation
import Combine

protocol TDTagSearchInteractorPresenterInterface: AnyObject {
    func fetchTagList() -> AnyPublisher<[String], Error>
}

final class TDTagSearchInteractor {
    weak var presenter: TDTagSearchPresenterInteractorInterface!
}

extension TDTagSearchInteractor: TDTagSearchInteractorPresenterInterface {
    func fetchTagList() -> AnyPublisher<[String], Error> {
        // fetch your data from API here
        
        // mocking
        return Future<[String], Error> { promise in
            if let path = Bundle.main.path(forResource: "tags", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()
                    
                    let tags = try decoder.decode([String].self, from: data)
                    promise(.success(tags))
                    return
                } catch {
                    // handle error
                    promise(.failure(NSError(domain: "Error: Failed to load tags from file", code: 400)))
                }
            }
            promise(.failure(NSError(domain: "Error: Failed to load tags from file", code: 400)))
        }.eraseToAnyPublisher()
    }
}
