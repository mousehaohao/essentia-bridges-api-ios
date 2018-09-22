//
//  LitecoinWalletInterface.swift
//  essentia-bridges-api-ios
//
//  Created by Pavlo Boiko on 05.07.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

fileprivate enum Constants {
    static var title: String = "Litecoin"
}

public protocol LitecoinWalletInterface: WalletInterface {
    func getBalance(for address: String, result: @escaping (Result<LitecoinBalance>) -> Void)
    func sendTransaction(with data: TransactionData, result: @escaping (Result<String>) -> Void)
    func getTransactionsHistory(for address: Address, result: @escaping (Result<String>) -> Void)
    func getUTxo(for address: Address, result: @escaping (Result<String>) -> Void)
    func getTransactionById(for id: TransactionId, result: @escaping (Result<String>) -> Void)
}

extension LitecoinWalletInterface {
    var title: String {
        return Constants.title
    }
}
