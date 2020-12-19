//
//  BaseAPI.swift
//  TMDBCase
//
//  Created by AppLogist on 17.12.2020.
//

import Foundation
import Moya

typealias SuccessBlock<T: Decodable> = ((T) ->())
typealias FailureBlock = ((PresentableError?) -> ())
typealias APIResult = Result<Moya.Response, MoyaError>


class BaseAPI<Target: BaseTarget> {
    private let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
    private var networkLogger : NetworkLoggerPlugin { NetworkLoggerPlugin(configuration: loggerConfig) }
    private var provider : MoyaProvider<Target> { MoyaProvider<Target>(plugins:[networkLogger]) }
    
    private var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    func process<T>(target: Target, failure: FailureBlock?, success: @escaping SuccessBlock<T>) where T: Decodable {
        provider.request(target) { [weak self] (result) in
            guard let self = self else { return }
            self.processResponse(result: result,
                                 success: success,
                                 failure: failure)
        }
    }
    
    private func processResponse<T>(result: APIResult, success: ((T) -> ())?, failure: FailureBlock?) where T: Decodable {
        switch result {
        case let .success(response):
            self.validate(
                response,
                success: { () in
                    do {
                        let data = try response.map(T.self,
                                                    atKeyPath: nil,
                                                    using: jsonDecoder,
                                                    failsOnEmptyData: false)
                        success?(data)
                    }catch MoyaError.statusCode(let response) {
                        failure?(PresentableError(title: "Error", message: "Unexpected Status code", code: response.statusCode))
                    } catch {
                        let error = MoyaError.requestMapping(error.localizedDescription)
                        failure?(PresentableError(message: error.localizedDescription))
                    }
                },
                error: { (error) in
                    failure?(error)
                }
            )

        case let .failure(error):
            debugPrint(error.localizedDescription)
            failure?(PresentableError(message: error.localizedDescription))
        }
    }

    private func validate(_ response: Response, success: (() -> ()), error: ((PresentableError?) -> ())) {
        if (response.statusCode >= 200) && (response.statusCode < 300) {
            success()
        } else {
            var presentableError: PresentableError? = nil
            do {
                let errorResponse = try response.map(APIError.self,
                                            atKeyPath: nil,
                                            using: jsonDecoder,
                                            failsOnEmptyData: false)
                presentableError = PresentableError(message: errorResponse.statusMessage ?? "")
            }
            catch {
                // Do Nothing
            }
            
            error(presentableError)
        }
    }
}
