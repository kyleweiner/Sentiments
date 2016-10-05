//
//  ActionRequestHandler.swift
//  Created by Kyle Weiner on 2/16/16.
//

import UIKit
import MobileCoreServices
//import SwiftyJSON

// MARK: - ActionRequestHandler

class ActionRequestHandler: NSObject {}

// MARK: - NSExtensionRequestHandling

extension ActionRequestHandler: NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let inputItem = context.inputItems.first as! NSExtensionItem
        let itemProvider = inputItem.attachments!.first as! NSItemProvider

        itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil) { (item, error) in
            let dictionary = item as! [String: AnyObject]
            let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [AnyHashable: Any]

            OperationQueue.main.addOperation { [unowned self] in
                self.handleItem(withContext: context, results: results)
            }
        }
    }

    fileprivate func handleItem(withContext context: NSExtensionContext, results: [AnyHashable: Any]) {
        guard let url = results["url"] as? String else {
            context.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        var request = SentimentAnalysisRequest(type: .url, parameterValue: url)

        request.successHandler = { response in
            let dictionary: [String: [String: AnyObject]]
            let positiveElements = response["positive"].arrayValue
            let negativeElements = response["negative"].arrayValue

            dictionary = [
                "error": [
                    "code": response["error"].intValue as AnyObject,
                    "reason": response["reason"].stringValue as AnyObject
                ],
                "colors": [
                    "positive": AppColor.positive.hexString() as AnyObject,
                    "negative": AppColor.negative.hexString() as AnyObject
                ],
                "sentiment": [
                    "positive": positiveElements.map() { $0["original_text"].stringValue } as AnyObject,
                    "negative": negativeElements.map() { $0["original_text"].stringValue } as AnyObject
                ]
            ]

            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: dictionary]
            let resultsProvider = NSItemProvider(item: resultsDictionary as NSSecureCoding?, typeIdentifier: String(kUTTypePropertyList))
            let resultsItem = NSExtensionItem()

            resultsItem.attachments = [resultsProvider]
            context.completeRequest(returningItems: [resultsItem], completionHandler: nil)
        }

        request.failureHandler = { error in
            context.completeRequest(returningItems: [], completionHandler: nil)
        }

        request.make()
    }
}
