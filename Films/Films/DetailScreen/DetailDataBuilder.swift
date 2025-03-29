//
//  DetailDataBuilder.swift
//  Films
//
//  Created by Артур Мавликаев on 11.01.2025.
//

import Foundation

struct DetailDataBuilder {
    static func buildRows(from filmDetail: FilmDetail) -> [DetailRow] {
        var rows: [DetailRow] = []
        rows.append(.poster(filmDetail.poster.image))
        rows.append(.title(filmDetail.title))
        if let description = filmDetail.description, !description.isEmpty {
            rows.append(.description("Описание: \(description)"))
        } else {
            rows.append(.description("Описание: отсутствует"))
        }
        let genresArray = filmDetail.genres.map { $0.name.capitalized }
        if genresArray.isEmpty {
            rows.append(.genres(["Жанры: не указаны"]))
        } else {
            rows.append(.genres(genresArray))
        }
        if let stars = filmDetail.stars, !stars.isEmpty {
            let starArray = stars
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            rows.append(.stars(starArray))
        } else {
            rows.append(.stars(["Актёры: не указаны"]))
        }
        let imdbText = filmDetail.imdbRating != nil
            ? "IMDb: \(filmDetail.imdbRating!)"
            : "Рейтинг IMDb отсутствует"
        rows.append(.imdbRating(imdbText))
        let runningTimeText = filmDetail.runningTime != nil
            ? "Длительность: \(filmDetail.runningTime!) минут"
            : "Длительность не указана"
        rows.append(.runningTime(runningTimeText))
        let trailerText = filmDetail.trailer ?? "Трейлер отсутствует"
        rows.append(.trailer(trailerText))
        return rows
    }
}
enum DetailRow: Hashable {
    case poster(String)
    case title(String)
    case genres([String])
    case stars([String])
    case description(String)
    case imdbRating(String)
    case runningTime(String)
    case trailer(String)
}
