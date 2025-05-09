import Foundation

public struct Stack<Element> {
    private var storage: [Element] = []
    
    public init(){}
    
    public init(_ elems: [Element]) {
        self.storage = elems
    }
    
    public mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    public mutating func pop() -> Element? {
        storage.popLast()
    }
    
    public func peek() -> Element? {
        storage.last
    }
    
    public func count() -> Int {
        storage.count
    }
}

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

let string = "(hello{()})"
var stack = Stack<Character>()
for i in string {
    if i == "(" || i == "{" || i == "[" {
        stack.push(i)
        continue
    }
    
    if i == ")" && stack.peek() == "(" || i == "}" && stack.peek() == "{"{
        stack.pop()
    }
}

if stack.count() == 0 {
    print("Correct")
} else {
    print("Incorrect")
}

