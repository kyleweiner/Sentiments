# Sentiments

![Platform: iOS](https://img.shields.io/badge/Platform-iOS-03A9F4.svg?style=flat)
![Sentiments Example](Assets/sentiments_example.gif)

Sentiments is an iOS app written in Swift that analyzes text for positive or negative sentiment. Positive sentiment is highlighted in green and negative sentiment is highlighted in red. The color of the interface reflects the aggregate sentiment of the analyzed text.

## Usage

### Sentiments

1. Open `Sentiment-Analysis.xcworkspace`.
2. Replace "YOUR_API_KEY" with your API key from [HPE Haven OnDemand](https://www.havenondemand.com) in [`AppConfig.swift`](https://github.com/kyleweiner/Sentiments/tree/master/Sentiment-Analysis/Constants/AppConfig.swift).
3. Enter text in the text field and press the check button.

### Highlight Sentiment Extension

The project includes an experimental action extension for analyzing the sentiment of text on a web page. The extension behaves similarly to the containing app–positive sentiment is highlighted in green and negative sentiment is highlighted in red. 

1. Launch Safari and navigate to a web page.
2. Tap the share button.
3. Tap the "Highlight Sentiment" icon.

Note that the extension must first be enabled to complete step 3.

## Author

Sentiments was written and designed by Kyle Weiner. It uses [Alamofire](https://github.com/Alamofire/Alamofire), [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) and [HPE Haven OnDemand](https://dev.havenondemand.com/apis/analyzesentiment#overview)'s Sentiment Analysis API.

## License

Copyright (c) 2016 Kyle Weiner. See the LICENSE file for details.