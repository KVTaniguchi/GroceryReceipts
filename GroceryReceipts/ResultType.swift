//
//  ResultType.swift
//  GroceryReceipts
//
//  Created by Kevin Taniguchi on 2/26/17.
//  Copyright © 2017 Kevin Taniguchi. All rights reserved.
//

import Foundation

extension Optional {
    func then(_ handler: (Wrapped) -> Void) {
        switch self {
        case .some(let wrapped):
            return handler(wrapped)
        case .none: break
        }
    }
}

public protocol ResultType {
    associatedtype Value
    
    init(_ value: Value?)
    init(_ error: Error)
    
    var value: Value? { get }
    var error: Error? { get }
}

public enum Result<T>: ResultType {
    public typealias Value = T
    
    case success(Value?)
    case failure(Error)
    
    public var value: Value? {
        switch self {
        case .success(let v):
            return v
        case .failure( _):
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .failure(let err):
            return err
        case .success(_):
            return nil
        }
    }
    
    public init(_ error: Error) {
        self = .failure(error)
    }
    
    public init(_ value: Value?) {
        if let v = value as? Error {
            self = .failure(v)
        }
        else if let v = value {
            self = .success(v)
        }
        else {
            self = .success(nil)
        }
        
    }
    
}
