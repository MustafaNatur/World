//
//  ConnectionProtocolProvider.swift
//  WorldVPN
//
//  Created by Mustafa on 10.10.2025.
//
import Foundation

protocol ConnectionProtocolProvider {
    func connect(server: Server) throws
    func disconnect() throws
}
