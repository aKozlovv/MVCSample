import UIKit

enum NetworkError {
    case invalidURL
    case errorNotNil
    case canNotCaptureSelf
    case badResponseCode
    case invalidData
    case canNotDecodeData
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let session = URLSession.shared
    
    private lazy var decoder = JSONDecoder()
    
    private let baseURL = "https://api.chucknorris.io/jokes/random"
    
    private init() {}
    
    typealias NetworkResult = (ViewData?, NetworkError?) -> Void
    
    
    func fetchData(completion: @escaping NetworkResult) throws {
        
        completion(.loading, nil)
        
        var networkError: NetworkError?
        
        guard let url = URL(string: baseURL) else {
            networkError = .invalidURL
            completion(.failure, networkError)
            return
        }
        
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { [weak self] data, response, error in
            
            guard error == nil else {
                networkError = .errorNotNil
                completion(.failure, networkError)
                return
            }
            
            guard let self = self else {
                networkError = .canNotCaptureSelf
                completion(.failure, networkError)
                return
            }
            
            guard checkResponseCode(response: response as! HTTPURLResponse) else {
                networkError = .badResponseCode
                completion(.failure, networkError)
                return
            }
            
            guard let parsData = data else {
                networkError = .invalidData
                completion(.failure, networkError)
                return
            }
            
            guard let result = try? self.decoder.decode(ViewData.Joke.self, from: parsData) else {
                networkError = .canNotDecodeData
                completion(.failure, networkError)
                return
            }
            
            completion(.success(result), networkError)
            
        }.resume()
    }
    
    private func checkResponseCode(response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
        case 200...299:
            return true
            
        case 300...399:
            return false
            
        case 400...499:
            return false
            
        case 500...599:
            return false
            
        default:
            return false
        }
    }
}
