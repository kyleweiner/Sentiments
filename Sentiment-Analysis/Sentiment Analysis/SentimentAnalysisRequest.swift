//
//  SentimentAnalysisRequest.swift
//  Created by Kyle Weiner on 2/4/16.
//

import Foundation
import Alamofire
import SwiftyJSON

enum SentimentAnalysisRequestType: String {
    case Text = "text"
    case URL = "url"
}

struct SentimentAnalysisRequest {
    private(set) var type: SentimentAnalysisRequestType!
    private(set) var parameterValue: String!

    var completionHandler: (Void -> Void)?
    var successHandler: (JSON -> Void)?
    var failureHandler: (NSError -> Void)?

    private var encodedUrl: String {
        let characters = NSCharacterSet.URLQueryAllowedCharacterSet()
        let encodedValue = parameterValue.stringByAddingPercentEncodingWithAllowedCharacters(characters)!

        let endpoint = AppConfig.SentimentAnalysisAPI.endpoint
        let key = AppConfig.SentimentAnalysisAPI.key

        return "\(endpoint)?\(type.rawValue)=\(encodedValue)&apikey=\(key)"
    }

    init(type: SentimentAnalysisRequestType, parameterValue: String) {
        self.type = type
        self.parameterValue = parameterValue
    }

    func makeRequest() {
        Alamofire.request(.GET, encodedUrl).responseJSON { response in
            self.completionHandler?()

            switch response.result {
            case .Success:
                let json = JSON(response.result.value!)
                self.successHandler?(json)
            case .Failure(let error):
                self.failureHandler?(error)
            }
        }
    }
}