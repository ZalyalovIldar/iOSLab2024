enum ReminderType: CaseIterable, Hashable, Codable{
    case water
    case vitamins
    case sleep
    case charge
    case food
    case breathing
    case stretch
    case custom(String)
    
    var description: String{
        switch self{
        case .water: return "Пить воду"
        case .vitamins: return "Принять витамины"
        case.sleep: return "Лечь спать"
        case.charge: return "Сделать зарядку"
        case.food: return "Покушать"
        case.breathing: return "Сделать дыхательные упражнения"
        case.stretch: return "Сделать растяжку"
        case.custom(let value): return value
        }
    }
    
    static var allCases: [ReminderType]{
        return[
            .water,
            .vitamins,
            .sleep,
            .charge,
            .food,
            .breathing,
            .stretch,
        ]
    }
    
    static func from(string: String) -> ReminderType{
        for type in Self.allCases{
            if type.description == string{
                return type
            }
        }
        return custom(string)
    }
    
    var isCustom: Bool{
        if case .custom = self{
            return true
        }
        else {
            return false
        }
    }
}
