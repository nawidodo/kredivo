//
//  Inject.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 03/06/23.
//

@propertyWrapper
struct Inject<Value> {
    private var value: Value?

    init() {
        self.value = nil
    }

    var wrappedValue: Value {
        get {
            guard let value = value else {
                fatalError("Dependency not provided for \(Value.self)")
            }
            return value
        }
        set {
            value = newValue
        }
    }
}

