//
//  SentimentAnalysisRequest.swift
//  Created by Kyle Weiner on 2/4/16.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SentimentAnalysisRequest {
    let text: String

    var completionHandler: (Void -> Void)?
    var successHandler: (JSON -> Void)?
    var failureHandler: (NSError -> Void)?

    private var encodedText: String {
        let characters = NSCharacterSet.URLQueryAllowedCharacterSet()

        return text.stringByAddingPercentEncodingWithAllowedCharacters(characters)!
    }

    private var url: String {
        let endpoint = AppConfig.SentimentAnalysisAPI.endpoint
        let key = AppConfig.SentimentAnalysisAPI.key

        return "\(endpoint)?text=\(encodedText)&apikey=\(key)"
    }

    init(text: String) {
        self.text = text
    }

    func makeRequest() {
        Alamofire.request(.GET, url).responseJSON { response in
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