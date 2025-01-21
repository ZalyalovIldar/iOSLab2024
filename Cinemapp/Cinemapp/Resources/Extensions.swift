import Foundation

extension String {
    func capitalizeOnlyFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
