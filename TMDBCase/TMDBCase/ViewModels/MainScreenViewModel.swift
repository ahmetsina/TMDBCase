//
//  MainScreenViewModel.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

typealias ErrorBlock = ((_ error: PresentableError?) -> ())

enum SearchItemType: CaseIterable {
    case movie
    case genre
    case person
    
    var title:  String {
        switch self {
            case .movie:
                return "Filtered By Movie Name"
            case .genre:
                return "Filtered By Genre Name"
            case .person:
                return "Filtered By Person Name"
        }
    }
    
    func results(from movies: [Movie], with query: String) -> [Movie] {
        switch self {
            case .movie:
                return movies.filter({ $0.title?.lowercased().contains(query.lowercased()) ?? false })
            case .genre:
                return movies.filter({ $0.genresStringWithComma?.lowercased().contains(query.lowercased()) ?? false })
            case .person:
                return movies.filter({ $0.credits?.cast?.contains(where: { $0.originalName?.lowercased().contains(query.lowercased()) ?? false}) ?? false})
        }
    }
}

class MainScreenViewModel {
    init() {}
    
    // APIS
    private let configApi = BaseAPI<ConfigurationTarget>()
    private let movieApi = BaseAPI<MovieTarget>()
    private let genreApi = BaseAPI<GenreTarget>()
    
    var reloadHandler: (()->())?
    
    var searchQuery = "" {
        didSet {
            search(with: searchQuery)
        }
    }
    
    var numberOfSections: Int {
        isSearchActive ? searchResults.count : 1
    }
    
    func numberOfItemsinSection(section: Int) -> Int {
        isSearchActive ? searchResultsMoviesCount(at: section) : movieCount
    }
    
    func movie(at indexPath:IndexPath) -> Movie {
        isSearchActive ? searchResultMovie(at: indexPath) : movie(at: indexPath.row)
    }
    
    var isSearchActive : Bool {
        !searchQuery.isEmpty
    }
    
    // Movies
    private var movies: [Movie] = [] {
        didSet {
            reloadHandler?()
        }
    }
    
    var searchResults: [SearchItemType] = [] {
        didSet {
            reloadHandler?()
        }
    }
    
    private func searchResultMovies(at section: Int) -> [Movie] {
        searchResults[section].results(from: movies, with: searchQuery)
    }
    
    private func searchResultMovie(at indexPath: IndexPath) -> Movie {
        searchResultMovies(at: indexPath.section)[indexPath.row]
    }
    
    private func searchResultsMoviesCount(at section: Int) -> Int {
        searchResults[section].results(from: movies, with: searchQuery).count
    }
    
    private var movieCount: Int { movies.count }
    
    private func movie(at index: Int) -> Movie { movies[index] }
    
    // MARK: - Service Calls
    
    // We can move to splash screen this check
    func getConfig(completion: @escaping ErrorBlock){
        if AppData.shared.config != nil {
            completion(nil)
            return
        }
        configApi.process(target: .getConfig) {(error) in
            completion(error)
        } success: { (response: Configuration) in
            AppData.shared.config = response
            completion(nil)
        }
    }
    
    func getGenres(completion: @escaping ErrorBlock){
        if !AppData.shared.genres.isEmpty {
            completion(nil)
            return
        }
        genreApi.process(target: .movieList) {(error) in
            completion(error)
        } success: { (response: GenresResponse) in
            AppData.shared.genres = response.genres ?? []
            completion(nil)
        }
    }
    
    
    /// Get Popular Movies From Services
    /// - Parameter completion: Handler error message
    func getPopularMovies(completion: @escaping ErrorBlock) {
        movieApi.process(target: .popular) { (error) in
            completion(error)
        } success: { [weak self] (response: PaginableResults<[Movie]>) in
            guard let self = self else { return }
            self.movies = response.results ?? []
            completion(nil)
        }
    }
    
    private func search(with query: String) {
        let fullSections = SearchItemType.allCases.filter({
                let filteredResults = $0.results(from: movies, with: query)
                return !filteredResults.isEmpty
        })
        searchResults = fullSections
    }
}
