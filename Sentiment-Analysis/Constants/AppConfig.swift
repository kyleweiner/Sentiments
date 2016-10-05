//
//  AppConfig.swift
//  Created by Kyle Weiner on 2/4/16.
//

struct AppConfig {
    /// The GitHub URL for this project.
    static let gitHubUrl = "https://github.com/kyleweiner/Sentiments"

    struct SentimentAnalysisAPI {
        /// The URL to the sentiment analysis API.
        static let endpoint = "https://api.havenondemand.com/1/api/sync/analyzesentiment/v1"

        /// The API key.
        static let key = "YOUR_API_KEY"
    }
}
