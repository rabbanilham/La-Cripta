//
//  NewsSharer.swift
//  La Cripta
//
//  Created by Bagas Ilham on 28/07/22.
//

import UIKit
import Kingfisher
import LinkPresentation

struct LCNewsSharer {
    static let shared = LCNewsSharer()
    
    func share(
        in viewController: UIViewController,
        article: LCArticleResponse,
        image: UIImage
    ) {
        let feedToShare: [Any] = [
            ActivityItemSource(title: article.title, text: article.source.name, image: image),
            URL(string: article.url)!
        ]
        let activityViewController = UIActivityViewController(activityItems: feedToShare, applicationActivities: nil)
        viewController.present(activityViewController, animated: true, completion: nil)
  }
  
}

class ActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String
    var image: UIImage
    
    init(title: String, text: String, image: UIImage) {
        self.title = title
        self.text = text
        self.image = image
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: image)
        metadata.originalURL = URL(fileURLWithPath: text)
        return metadata
    }

}
