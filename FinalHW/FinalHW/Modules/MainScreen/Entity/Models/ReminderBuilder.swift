class ReminderBuilder {
    private var title = ""
    private var interval = 1
    private var type = ReminderType.water
    
    func with(title: String) -> Self {
        self.title = title
        return self
    }
    
    func with(interval: Int) -> Self {
        self.interval = interval
        return self
    }
    
    func with(type: ReminderType) -> Self {
        self.type = type
        return self
    }
    
    func build() -> Reminder {
        return Reminder(title: title, interval: interval, type: type)
    }
}
