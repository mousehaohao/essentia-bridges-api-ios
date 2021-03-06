//
//  BitcoinCashWalletTests.swift
//  Essentia-bridges-api-ios-tests
//
//  Created by Binomial on 27.09.2018.
//  Copyright © 2018 Essentia. All rights reserved.
//

import XCTest
@testable import essentia_bridges_api_ios
import HDWalletKit

private var url = "https://b3.essentia.network"
private var apiVersion = "/api/v1"
private var serverUrl = url + apiVersion

private var addressFrom = "qzs02v05l7qs5s24srqju498qu55dwuj0cx5ehjm2c"
private var transactionData = "010000000178bd2a3f1568c9d3c77646c52ef13540bd23b67a161291e5fba5c71713106ef9010000006a473044022000e7189b5d64430f16f5c707ee62430cb7cd51c94e1df6c4aed6336ec97840cf022009d499edeca8f75bca41854bb83738ba3ef06f207c0174bebf801aa45f3aec154121029a0149a3c03da674db434641bd1e454431dd155e7b1eec1bbb5b12137f428973ffffffff02400d0300000000001976a914f54a05495c2c097d4486a66dfd4a7f7d2f22ac7388ac3ece0200000000001976a91479ee663132bb6cb5c85eafd68a4d63c611142bc988ac00000000"

private var expectedTxId: String =  "f53fb9bcdde78bcf580efacb6ce777bde5e345a9392e5ed3f3e84fe15a63cf1a"
private var expectedBalance = 0.0211909

private struct ExpectedTransactionHistory {
    static public let fromNumber: Int = 0
    static public let toNumber: Int = 3
    static public let totalItems: Int = 3
}

private struct ExpectedTransactionbyId {
    static public let blockhash: String = "000000000000000001df56329b3831c92b953c2266f97ee7d7632b3d37a1234d"
    static public let blockheight: Int = 550283
    static public let blocktime: Int = 1538397562
    static public let confirmations: Int = 23
    static public let fees: Double = 0
    static public let size: Int = 121
    static public let time: Int = 1538397562
    static public let txid: String = "f53fb9bcdde78bcf580efacb6ce777bde5e345a9392e5ed3f3e84fe15a63cf1a"
    static public let valueIn: Double = 0
    static public let valueOut: Double = 12.53848559
    
    public struct Vin {
        static public let coinbase: String = "038b6508174d696e656420627920416e74506f6f6c353c205bb2157a502a000027160300"
        static public let sequence: Int = 4294967295
        static public let number: Int = 0
    }
    public struct Vout {
        static public let addresses: [String] = ["13usM2ns3f466LP65EY1h8hnTBLFiJV6rD"]
        static public let txid: String? = nil
        static public let value: String = "12.53848559"
    }
}

class BitcoinCashTests: XCTestCase {
    var bchWallet: BitcoinCashWallet?
    
    override func setUp() {
        bchWallet = BitcoinCashWallet(serverUrl)
    }
    
    func testGetBalance() {
        let expectation = self.expectation(description: "Get balance")
        bchWallet?.getBalance(for: addressFrom, result: { (result) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail(expectation.description)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetTransactionsHistory() {
        let expectation = self.expectation(description: "Get transactions history")
        bchWallet?.getTransactionsHistory(for: addressFrom, result: { (result) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail(expectation.description)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
   
    func testGetTransactionById() {
        let expectation = self.expectation(description: "Get transaction by id")
        bchWallet?.getTransactionById(for: expectedTxId, result: { (result) in
            switch result {
            case .success(let object):
                XCTAssertEqual(object.blockhash, ExpectedTransactionbyId.blockhash)
                XCTAssertEqual(object.blocktime, ExpectedTransactionbyId.blocktime)
                XCTAssertEqual(object.blockheight, ExpectedTransactionbyId.blockheight)
                XCTAssertEqual(object.size, ExpectedTransactionbyId.size)
                XCTAssertEqual(object.time, ExpectedTransactionbyId.time)
                XCTAssertEqual(object.txid, ExpectedTransactionbyId.txid)
                XCTAssertEqual(object.fees, ExpectedTransactionbyId.fees)
                XCTAssertEqual(object.valueIn, ExpectedTransactionbyId.valueIn)
                XCTAssertEqual(object.valueOut, ExpectedTransactionbyId.valueOut)
                XCTAssertEqual(object.vin[0].sequence, ExpectedTransactionbyId.Vin.sequence)
                XCTAssertEqual(object.vin[0].number, ExpectedTransactionbyId.Vin.number)
                XCTAssertEqual(object.vout[0].scriptPubKey.addresses, ExpectedTransactionbyId.Vout.addresses)
                XCTAssertEqual(object.vout[0].value, ExpectedTransactionbyId.Vout.value)
                expectation.fulfill()
            case .failure:
                XCTFail(expectation.description)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSendTX() {
        
        let expectation = self.expectation(description: "Send TX")
        bchWallet?.sendTransaction(with: transactionData, result: { (result) in
            switch result {
            case .success(let object):
                print(object.txid)
                expectation.fulfill()
            case .failure(let error):
                switch error {
                case .error(let localizedErr):
                    XCTAssert(localizedErr.error != "")
                    expectation.fulfill()
                case .unknownError:
                    XCTFail(expectation.description)
                case .defaultError(let error):
                    XCTFail(error.localizedDescription)
                }
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
