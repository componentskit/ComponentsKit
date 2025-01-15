import UIKit

struct ImageLoader {
  private static var cache = NSCache<NSString, UIImage>()

  private init() {}

  static func download(url: URL) async -> UIImage? {
    if let image = self.cache.object(forKey: url.absoluteString as NSString) {
      return image
    }

    let request = URLRequest(url: url)
    guard let (data, _) = try? await URLSession.shared.data(for: request),
          let image = UIImage(data: data) else {
      return nil
    }

    self.cache.setObject(image, forKey: url.absoluteString as NSString)
    return image
  }
}
