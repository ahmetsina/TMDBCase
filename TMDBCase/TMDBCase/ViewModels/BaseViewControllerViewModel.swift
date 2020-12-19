//
//  BaseViewControllerViewModel.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

protocol BaseViewControllerViewModel: class {
    associatedtype T
    init(viewModel: T)
}
