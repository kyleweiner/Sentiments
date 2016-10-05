//
//  SentimentAnalysisRequest.swift
//  Created by Kyle Weiner on 2/4/16.
//

import Foundation
import Alamofire
import SwiftyJSON

enum SentimentAnalysisRequestType: String {
    case text, url
}

struct SentimentAnalysisRequest {
    fileprivate(set) var type: SentimentAnalysisRequestType!
    fileprivate(set) var parameterValue: String!

    var completionHandler: ((Void) -> Void)?
    var successHandler: ((JSON) -> Void)?
    var failureHandler: ((NSError) -> Void)?

    fileprivate var encodedUrl: String {
        let characters = CharacterSet.urlQueryAllowed
        let encodedValue = parameterValue.addingPercentEncoding(withAllowedCharacters: characters)!

        let endpoint = AppConfig.SentimentAnalysisAPI.endpoint
        let key = AppConfig.SentimentAnalysisAPI.key

        return "\(endpoint)?\(type.rawValue)=\(encodedValue)&apikey=\(key)"
    }

    init(type: SentimentAnalysisRequestType, parameterValue: String) {
        self.type = type
        self.parameterValue = parameterValue
    }

    func make() {
        Alamofire.request(encodedUrl).responseJSON { response in
            self.completionHandler?()

            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                self.successHandler?(json)
            case .failure(let error):
                self.failureHandler?(error as NSError)
            }
        }
    }
}
