import Foundation
import Alamofire

protocol NetworkManagerProtocol: AnyObject {
    func request<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func request<T>(completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        guard let url = URL(string: BaseUrlResponse.baseURL) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let params: Parameters? = nil
        AF.request(url, parameters: params)
            .validate(statusCode: 200..<300)
            .response { res in
                if let error = res.error {
                    completion(.failure(error))
                    return
                }
                guard let data = res.data else {
                    completion(.failure(URLError(.cannotDecodeRawData)))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
