import Foundation
import UIKit

class DALLEManager {

    static let shared = DALLEManager()
    private let baseUrlString = "https://api.openai.com/v1/" // Use the actual base URL for DALL-E API

    func generateImage(from prompt: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let endpoint = "images/generations" // Update this with the correct endpoint if different
        guard let url = URL(string: baseUrlString + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer YOUR_API_TOKEN", forHTTPHeaderField: "Authorization") // Replace with your actual token
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(NetworkError.encodingError))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.unexpectedStatusCode))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                // Assuming the API returns JSON with a field "data" that is an array of dictionaries containing "url" of the image
                let jsonResponse = try JSONDecoder().decode(DALLEImageResponse.self, from: data)
                guard let imageUrlString = jsonResponse.data.first?.url,
                      let imageUrl = URL(string: imageUrlString) else {
                    completion(.failure(NetworkError.urlGeneration))
                    return
                }

                // Now download the image
                self.downloadImage(fromURL: imageUrl, completion: completion)
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }

    // Helper function to download image from a URL
    private func downloadImage(fromURL url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NetworkError.imageDownload))
                return
            }

            completion(.success(image))
        }.resume()
    }
}

// MARK: - DALL-E Image Response Decodable Structure
struct DALLEImageResponse: Decodable {
    var data: [DALLEImageData]
}

struct DALLEImageData: Decodable {
    var url: String
}

// MARK: - Network Error Enumeration
enum NetworkError: Error {
    case invalidURL
    case encodingError
    case unexpectedStatusCode
    case noData
    case decodingError
    case urlGeneration
    case imageDownload
}
