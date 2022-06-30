import Foundation
public class ZNetwork {
    
    private var environment: EnvironmentProtocol
    private var urlSession: URLSession
    
    public init(environment: EnvironmentProtocol, urlSession: URLSession = .shared) {
        self.environment = environment
        self.urlSession = urlSession
    }
    
    public func execute<T: Codable>(request: RequestProtocol, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlReq = request.urlRequest(with: environment) else {
            completion(.failure(NetworkError.badRequest("Bad URL request")))
            return
        }
        
        self.urlSession.dataTask(with: urlReq) { data, response, error in
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            let result = self.verify(data: data, urlResponse: urlResponse, error: error)
            
            switch result {
            case .success(let data):
                let parsedResult: Result<T, Error> = self.parse(data: data as? Data)
                switch parsedResult {
                case .success(let result):
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.parseError(error.localizedDescription)))
                    }
                }
            case .failure(let error):
                completion(.failure(NetworkError.serverError(error.localizedDescription)))
            }
        }.resume()
    }
    
    /// Parses a `Data` object into a JSON object.
    /// - Parameter data: `Data` instance to be parsed.
    /// - Returns: A `Result` instance with codable item.
    private func parse<T: Codable>(data: Data?) -> Result<T, Error> {
        guard let data = data else {
            return .failure(NetworkError.invalidResponse)
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch (let exception) {
            return .failure(NetworkError.parseError(exception.localizedDescription))
        }
    }
    
    /// Checks if the HTTP status code is valid and returns an error otherwise.
    /// - Parameters:
    ///   - data: The data or file  URL .
    ///   - urlResponse: The received  optional `URLResponse` instance.
    ///   - error: The received  optional `Error` instance.
    /// - Returns: A `Result` instance.
    private func verify(data: Any?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Any, Error> {
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(NetworkError.noData)
            }
        case 400...499:
            return .failure(NetworkError.badRequest(error?.localizedDescription))
        case 500...599:
            return .failure(NetworkError.serverError(error?.localizedDescription))
        default:
            return .failure(NetworkError.unknown)
        }
    }
}
