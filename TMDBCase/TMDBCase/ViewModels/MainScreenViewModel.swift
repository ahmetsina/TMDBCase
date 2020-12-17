//
//  MainScreenViewModel.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

struct MainScreenViewModel {
    
    private let configApi = BaseAPI<ConfigurationTarget>()
    
    // We can move to splash screen this chech
    func getConfig(completion: @escaping ((_ errorMessage: String?) -> ())){
        if AppData.shared.config != nil { return }
        configApi.process(target: .getConfig) { (error) in
            completion(error?.message)
        } success: { (response: Configuration) in
            AppData.shared.config = response
            completion(nil)
        }
    }
}
