//
//  MovieCollectionCellViewModel.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import Foundation

struct MovieCollectionCellViewModel {
    public init(imageURL: URL? = nil,
                title: String? = nil,
                subTitle: String? = nil) {
        self.imageURL = imageURL
        self.title = title
        self.subTitle = subTitle
    }
    
    private(set) var imageURL: URL?
    private(set) var title: String?
    private(set) var subTitle: String?
}
