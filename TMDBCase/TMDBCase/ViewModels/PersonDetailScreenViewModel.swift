//
//  PersonDetailScreenViewModel.swift
//  TMDBCase
//
//  Created by AppLogist on 19.12.2020.
//

import Foundation

class PersonDetailScreenViewModel {
    
    private let personApi = BaseAPI<PersonTarget>()
    var person : Person?
    private let personID: Int?
    
    init(personID: Int) {
        self.personID = personID
    }
    
    func cast(at index: Int) -> Movie? { person?.credits?.cast?[index] }
    var castCount: Int { person?.credits?.cast?.count ?? 0 }
    
    func getPersonDetail(completion: @escaping ErrorBlock) {
        let request = QueryRequest(appendToResponse: [.credits,.images], personID: personID)
        personApi.process(target: .details(request)) { (error) in
            completion(error)
        } success: { [weak self] (response: Person) in
            guard let self = self else { return }
            self.person = response
            completion(nil)
        }
    }
}
