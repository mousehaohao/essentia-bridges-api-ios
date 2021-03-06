//
//  EthereumSmartContractTests.swift
//  Essentia-bridges-api-ios-tests
//
//  Created by Pavlo Boiko on 10/8/18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import XCTest
@testable import essentia_bridges_api_ios
import HDWalletKit

fileprivate var url = "https://b3.essentia.network"
fileprivate var apiVersion = "/api/v1"
fileprivate var serverUrl = url + apiVersion
fileprivate var ethterScanUrl = "http://api.etherscan.io"
fileprivate var etherScanApiKey = "IH2B5YWPTT3B19KMFYIFPMD85SQ7A12BDU"
fileprivate var address = "0x34205555576717bBdF8158E2b2c9ed64EB1e6B85"

fileprivate enum TokenBalance {
    static var smartContractAddress = "0x8f0921f30555624143d427b340b1156914882c10"
    static var smartContractData = "0x70a082310000000000000000000000002f5059f64D5C0c4895092D26CDDacC58751e0C3C"
}

class EthereumSmartContractsTests: XCTestCase {
    var ethWallet: EthereumWallet?
    
    override func setUp() {
        ethWallet = EthereumWallet(serverUrl, etherScan: EtherScanInfo(url: ethterScanUrl, apiKey: etherScanApiKey))
    }
    
    func testGetTokenBalance() {
        let expectation = self.expectation(description: "Get token balance")
        let smartContract = EthereumSmartContract(to: TokenBalance.smartContractAddress,
                                                  data: TokenBalance.smartContractData)
        ethWallet?.getTokenBalance(info: smartContract, result: { (result) in
                                        switch result {
                                        case .success(let object):
                                            print(object.balance)
                                            expectation.fulfill()
                                        case .failure:
                                            XCTFail(expectation.description)
                                        }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAddressTransactionHistory() {
        let expectation = self.expectation(description: "Get transaction history")
        ethWallet?.getTxHistory(for: address, result: { (result) in
            switch result {
            case .success(let object):
                XCTAssert(object.result.count != 0)
                expectation.fulfill()
            case .failure:
                XCTFail(expectation.description)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
