import Foundation

protocol Storable: Codable, Identifiable, Equatable {}
extension TaskItem: Storable {}