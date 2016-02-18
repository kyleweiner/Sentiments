//
//  Action.js
//  Created by Kyle Weiner on 2/16/16.
//

var Action = function() {};

Action.prototype = {
    run: function(arguments) {
        // Passes the HTML document's `url` property to the app's native code.
        arguments.completionFunction({ "url": window.location.href })
    },

    finalize: function(arguments) {
        // Shows an alert if there is an error message.
        if (reason = arguments.error.reason) {
            return alert(reason);
        }

        // Highlights the positive and negative sentiments in the document.
        var sentiment = arguments.sentiment,
            colors = arguments.colors,
            foregroundColor = "white";

        if (sentiment.positive.length != 0) {
            this.highlight(sentiment.positive, colors.positive, foregroundColor)
        }

        if (sentiment.negative.length != 0) {
            this.highlight(sentiment.negative, colors.negative, foregroundColor)
        }
    },

    highlight: function(textArray, backgroundColor, foregroundColor) {
        document.designMode = "on"

        var selection = window.getSelection();
        selection.collapse(document.body, 0);

        for (i in textArray) {
            var text = textArray[i];
            while (window.find(text)) {
                document.execCommand("hiliteColor", false, backgroundColor);
                document.execCommand("foreColor", false, foregroundColor);
                selection.collapseToEnd();
            }
        }

        document.designMode = "off";
    }
};

var ExtensionPreprocessingJS = new Action