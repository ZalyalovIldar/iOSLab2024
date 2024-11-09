import Foundation
import UIKit
struct Post: Hashable, Identifiable {
    let date: String
    var description: String
    var pictures: [String]
    let id: UUID
}
