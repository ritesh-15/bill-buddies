//
//  ResponseMapperProtocol.swift
//  BillBuddies
//
//  Created by Ritesh Khore on 11/01/26.
//

import Foundation

protocol ResponseMapperProtocol {
    associatedtype Input
    associatedtype Output

    static func toDomain(_ dto: Input) -> Output
}
