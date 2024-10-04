//
//  DataDelegateProtocol.swift
//  Profiler
//
//  Created by Тимур Салахиев on 03.10.2024.
//

import Foundation

protocol DataDelegate: AnyObject {
    func sendData(data: String)
}
