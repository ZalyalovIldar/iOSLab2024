struct MovieDetail: Codable {
    let id: Int
    let title: String
    let description: String
    let year: Int
    let duration: Int?
    let genres: [Genre]
    struct Genre: Codable {
        let name: String
    }
    let rating: Double?
    let actors: [String]?
    
    // Обновлено: poster теперь содержит объект Poster
    let poster: Poster?
    
    // Структура Poster
    struct Poster: Codable {
        let image: String  // URL изображения
        let source: Source  // Источник изображения
    }
    
    struct Source: Codable {
        let name: String
        let link: String
    }
    
    let images: [Image]
    
    struct Image: Codable {
        let image: String  // URL изображения
        let source: Source  // Источник изображения
    }
    
    let trailer: String?
}


