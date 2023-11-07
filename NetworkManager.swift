import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.openai.com/v1/"
    private let apiKey = "YOUR_API_KEY"

    private init() {}

    // Function to handle HTTP status codes
    private func handleHTTPResponse(_ response: URLResponse?) -> NetworkError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299: return nil // Success response
        case 401: return .authenticationError
        case 403: return .authorizationError
        case 404: return .notFound
        case 500...599: return .serverError
        default: return .unexpectedStatusCode
        }
    }

    // Enhanced function to perform a request with retry logic
    private func performRequestWithRetry<T: Decodable>(endpoint: String, method: String = "GET", parameters: [String: Any]? = nil, retries: Int = 3, completion: @escaping (Result<T, Error>) -> Void) {
        // ...

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // ...

                // Retry logic in case of connectivity issues
                if (error as NSError).domain == NSURLErrorDomain && retries > 0 {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { // Retry after 2 seconds
                        self.performRequestWithRetry(endpoint: endpoint, method: method, parameters: parameters, retries: retries - 1, completion: completion)
                    }
                }
                return
            }

            if let networkError = self.handleHTTPResponse(response) {
                // ...

                // Retry logic for server errors
                if networkError == .serverError && retries > 0 {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { // Retry after 2 seconds
                        self.performRequestWithRetry(endpoint: endpoint, method: method, parameters: parameters, retries: retries - 1, completion: completion)
                    }
                } else {
                    completion(.failure(networkError))
                }
                return
            }

            // ...
        }.resume()
    }
  func fetchPortfolioItems(completion: @escaping (Result<[PortfolioItem], Error>) -> Void) {
      let urlString = "\(baseUrlString)/portfolioItems"
      guard let url = URL(string: urlString) else { return }

      URLSession.shared.dataTask(with: url) { data, response, error in
          if let error = error {
              completion(.failure(error))
              return
          }

          guard let data = data else {
              completion(.failure(NSError(domain: "No data", code: 0)))
              return
          }

          do {
              let items = try JSONDecoder().decode([PortfolioItem].self, from: data)
              completion(.success(items))
          } catch {
              completion(.failure(error))
          }
      }.resume()
  }

  
    // ...

    // Generate Image function and Download Image function remains the same
    // ...
}

// MARK: - Network Error Enumeration
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case authenticationError
    case authorizationError
    case notFound
    case serverError
    case unexpectedStatusCode
    case encodingError
    case noData
    case decodingError
    case urlGeneration
    case imageDownload
}

// MARK: - DALL-E Image Response Decodable Structure
// ...

// Usage of the networking layer should be the same
