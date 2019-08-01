//
//  WebImageView.swift
//  VKNewsFeed
//
//  Created by Алексей Пархоменко on 23/03/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(imageURL: String?) {
        
        guard let url = imageURL?.url() else {
            self.image = nil
            return
        }
        if let cachedImage = self.getCachedImage(url: url) {
            self.image = cachedImage
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let responseURL = response?.url else {
                return
            }
            if responseURL.absoluteString != imageURL {
                return
            }
            guard let data = data, let response = response else {
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
            self?.saveImageCache(data: data, response: response)
        }
        dataTask.resume()
    }

    private func getCachedImage(url: URL) -> UIImage? {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }

    private func saveImageCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else {
            return
        }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}

fileprivate extension String {
    func url() -> URL? {
        guard let url = URL(string: self) else {
            return nil
        }
        return url
    }
}
