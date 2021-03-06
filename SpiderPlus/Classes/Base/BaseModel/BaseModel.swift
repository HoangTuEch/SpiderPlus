//
//  BaseModel.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/18/22.
//

import Foundation

// Model Protocol
public protocol BaseModel: Codable {
    associatedtype ModelType: Codable = Self
}

extension BaseModel {

    /// Objectから生成
    public static func fromObject(_ object: Any,
                                  options: JSONSerialization.WritingOptions = .prettyPrinted) -> ModelType {
        return fromJson(try! JSONSerialization.data(withJSONObject: object, options: options))
    }

    /// JSON文字列から生成
    public static func fromJson(_ json: String) -> ModelType {
        return fromJson(json.data(using: .utf8)!)
    }

    /// JSONデータから生成
    public static func fromJson(_ json: Data) -> ModelType {
        return try! JSONDecoder().decode(Self.self, from: json) as! Self.ModelType
    }

    /// JSONデータからデコード可能かどうか
    public static func canDecodeFromJson(_ json: Data) -> Bool {
        if (try? JSONDecoder().decode(Self.self, from: json) as? Self.ModelType) == nil {
            return false
        }
        return true
    }
}
