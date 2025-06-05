import Foundation

enum APIError: Error{
    case failedToGetData
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/?fields=id,title,poster") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(results.results))
                print(results)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMoviesByCity(citySlug: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/movies/?location=\(citySlug)&page=\(page)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
                //print(citySlug)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func getCities(completion: @escaping (Result<[City], Error>) -> Void) {
        guard let url = URL(string: "https://kudago.com/public-api/v1.4/locations/?lang=ru") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let cityResponse = try JSONDecoder().decode([City].self, from: data)
                completion(.success(cityResponse))
                //print(cityResponse)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://kudago.com/public-api/v1.4/movies/?fields=id,title,description,poster&text_format=text&expand=poster&q=\(encodedQuery)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 204, userInfo: nil)))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MovieResponse.self, from: data)
                let lowercaseQuery = query.folding(options: .diacriticInsensitive, locale: .current).lowercased()
                let filteredMovies = results.results.filter { movie in
                    let lowercaseTitle = movie.title.folding(options: .diacriticInsensitive, locale: .current).lowercased()
                    return lowercaseTitle.contains(lowercaseQuery)
                }
                completion(.success(filteredMovies))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
