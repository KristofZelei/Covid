//
//  Response.swift
//  Covid
//
//  Created by Foltányi Kolos on 2020. 04. 01..
//  Copyright © 2020. Foltányi Kolos. All rights reserved.
//

import Foundation

protocol Response: Codable {
    associatedtype DataType
    var error: Bool { get set }
    var statusCode: Int { get set }
    var message: String { get set }
    var data: DataType { get set }
}
