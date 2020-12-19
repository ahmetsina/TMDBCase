//
//  MainScreenViewModel.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation

typealias ErrorBlock = ((_ error: PresentableError?) -> ())

class MainScreenViewModel {
    init() {}
    // APIS
    private let configApi = BaseAPI<ConfigurationTarget>()
    private let movieApi = BaseAPI<MovieTarget>()
    private let genreApi = BaseAPI<GenreTarget>()
    
    var moviesReloadHandler: (()->())?
    
    // Movies
    private var movies: [Movie] = [] {
        didSet {
            moviesReloadHandler?()
        }
    }
    var movieCount: Int { movies.count }
    
    func movie(at index: Int) -> Movie { movies[index] }
    
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
}
