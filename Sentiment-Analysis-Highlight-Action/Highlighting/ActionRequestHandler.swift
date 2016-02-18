//
//  ActionRequestHandler.swift
//  Created by Kyle Weiner on 2/16/16.
//

import UIKit
import MobileCoreServices
import SwiftyJSON

// MARK: - ActionRequestHandler

class ActionRequestHandler: NSObject {}

// MARK: - NSExtensionRequestHandling

extension ActionRequestHandler: NSExtensionRequestHandling {
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        let inputItem = context.inputItems.first as! NSExtensionItem
        let itemProvider = inputItem.attachments!.first as! NSItemProvider

        itemProvider.loadItemForTypeIdentifier(String(kUTTypePropertyList), options: nil) { (item, error) in
            let dictionary = item as! [String: AnyObject]
            let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [NSObject: AnyObject]

            NSOperationQueue.mainQueue().addOperationWithBlock { [unowned self] in
                self.handleItem(withContext: context, results: results)
            }
        }
    }

    private func handleItem(withContext context: NSExtensionContext, results: [NSObject: AnyObject]) {
        guard let url = results["url"] as? String else {
            context.completeRequestReturningItems([], completionHandler: nil)
            return
        }

        var request = SentimentAnalysisRequest(type: .URL, parameterValue: url)

        request.successHandler = { response in
            let dictionary: [String: [String: AnyObject]]
            let positiveElements = response["positive"].arrayValue
            let negativeElements = response["negative"].arrayValue

            dictionary = [
                "error": [
                    "code": response["error"].intValue,
                    "reason": response["reason"].stringValue
                ],
                "colors": [
                    "positive": UIColor.positiveColor().hexString(),
                    "negative": UIColor.negativeColor().hexString()
                ],
                "sentiment": [
                    "positive": positiveElements.map() { $0["original_text"].stringValue },
                    "negative": negativeElements.map() { $0["original_text"].stringValue }
                ]
            ]

            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: dictionary]
            let resultsProvider = NSItemProvider(item: resultsDictionary, typeIdentifier: String(kUTTypePropertyList))
            let resultsItem = NSExtensionItem()

            resultsItem.attachments = [resultsProvider]
            context.completeRequestReturningItems([resultsItem], completionHandler: nil)
        }

        request.failureHandler = { error in
            context.completeRequestReturningItems([], completionHandler: nil)
        }

        request.makeRequest()
    }
}