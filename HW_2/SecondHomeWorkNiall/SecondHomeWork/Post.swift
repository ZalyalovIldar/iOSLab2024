import Foundation
import UIKit

struct Post: Hashable, Identifiable {
    let text: String
    let date: String
    let pictures: [String]
    let id: UUID
}
 
