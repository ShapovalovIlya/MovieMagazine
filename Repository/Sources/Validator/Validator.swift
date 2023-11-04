//
//  Validator.swift
//
//
//  Created by Илья Шаповалов on 06.10.2023.
//

import Foundation

public struct Validator {
    public var validateName: (String) -> Bool
    public var validateEmail: (String) -> Bool
    public var validatePassword: (String) -> Bool
    public var isEmpty: (String) -> Bool
    
    //MARK: - Live
    public static let live = Self(
        validateName: validate(username:),
        validateEmail: validate(email:),
        validatePassword: validate(password:),
        isEmpty: isEmpty(_:)
    )
    
    //MARK: - init(_:)
    
    /// Set empty Validator with unimplemented properties. If you doesn't set in, raise `fatalError` while execute.
    public init(
        validateName: @escaping (String) -> Bool = { _ in fatalError("Unimplemented") },
        validateEmail: @escaping (String) -> Bool = { _ in fatalError("Unimplemented") },
        validatePassword: @escaping (String) -> Bool = { _ in fatalError("Unimplemented") },
        isEmpty: @escaping (String) -> Bool = { _ in fatalError("Unimplemented") }
    ) {
        self.validateName = validateName
        self.validateEmail = validateEmail
        self.validatePassword = validatePassword
        self.isEmpty = isEmpty
    }
    
    //MARK: - Public methods
    public static func validate(email: String) -> Bool {
        guard let emailDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let rangeToValidate = NSRange(
            email.startIndex..<email.endIndex,
            in: email
        )
        let matches = emailDetector.matches(
            in: email,
            range: rangeToValidate
        )
        guard
            matches.count == 1,
            let singleMatch = matches.first,
            singleMatch.url?.scheme == "mailto"
        else {
            return false
        }
        return true
    }
    
    public static func validate(password: String) -> Bool {
        guard password.count > 7 else {
            return false
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            .init(format: .matchesPredicate, Regex.uppercasedChar),
            .init(format: .matchesPredicate, Regex.digit),
            .init(format: .matchesPredicate, Regex.lowercasedChar),
            .init(format: .matchesPredicate, Regex.symbol)
        ])
        .evaluate(with: password)
    }
    
    public static func isEmpty(_ string: String) -> Bool {
        string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public static func validate(username: String) -> Bool {
        guard username.count > 6 else {
            return false
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            .init(format: .matchesPredicate, Regex.uppercasedChar),
            .init(format: .matchesPredicate, Regex.lowercasedChar)
        ])
        .evaluate(with: username)
    }
}

extension Validator {
    struct Regex {
        static let uppercasedChar = ".*[A-Z]+.*"
        static let digit = ".*[0-9]+.*"
        static let lowercasedChar = ".*[a-z]+.*"
        static let symbol = ".*[!&^%$#@()/]+.*"
    }
}
