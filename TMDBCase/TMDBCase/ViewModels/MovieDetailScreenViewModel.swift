//
//  MovieDetailScreenViewModel.swift
//  TMDBCase
//
//  Created by AppLogist on 18.12.2020.
//

import Foundation

class MovieDetailScreenViewModel {

    private let movieID: Int?
    private let movieApi = BaseAPI<MovieTarget>()
    
    var movie: Movie?

    init(movieID: Int?) {
        self.movieID = movieID
    }
    
    func cast(at index: Int) -> Person? { movie?.credits?.cast?[index] }
    var castCount: Int { movie?.credits?.cast?.count ?? 0 }
    
    func video(at index: Int) -> Video? { movie?.videos?.results?[index] }
    var videosCount: Int { movie?.videos?.results?.count ?? 0 }
    
    // MARK: - Service Calls
    func getMovieDetail(completion: @escaping ErrorBlock) {
        let request = QueryRequest(appendToResponse: [.videos,.credits], movieID: movieID)
        movieApi.process(target: .details(request)) { (error) in
            completion(error)
        } success: { [weak self] (response: Movie) in
            guard let self = self else { return }
            self.movie = response
            completion(nil)
        }
    }
}
