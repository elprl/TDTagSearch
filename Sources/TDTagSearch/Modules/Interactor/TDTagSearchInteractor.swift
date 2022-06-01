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
    func fetchTagList(path: String?) -> AnyPublisher<[String], Error>
}

final public class TDTagSearchInteractor {
    weak var presenter: TDTagSearchPresenterInteractorInterface!
}

extension TDTagSearchInteractor: TDTagSearchInteractorPresenterInterface {
    func fetchTagList(path: String? = Bundle.module.path(forResource: "tags", ofType: "json")) -> AnyPublisher<[String], Error> {
        // fetch your data from API here
        
        // mocking
        return Future<[String], Error> { promise in
            DispatchQueue.global().async {
                if let path = path {
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
            }
        }.eraseToAnyPublisher()
    }
}
