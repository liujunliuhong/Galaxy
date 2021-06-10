//
//  BIP44.swift
//  Galaxy
//
//  Created by liujun on 2021/6/9.
//

import Foundation

/// m / purpose' / coin_type' / account' / change / address_index

/// Purpose
/// Purpose is a constant set to 44' (or 0x8000002C) following the BIP43 recommendation. It indicates that the subtree of this node is used according to this specification.
/// Hardened derivation is used at this level.


/// Coin type
/// One master node (seed) can be used for unlimited number of independent cryptocoins such as Bitcoin, Litecoin or Namecoin. However, sharing the same space for various cryptocoins has some disadvantages.
/// This level creates a separate subtree for every cryptocoin, avoiding reusing addresses across cryptocoins and improving privacy issues.
/// Coin type is a constant, set for each cryptocoin. Cryptocoin developers may ask for registering unused number for their project.
/// Hardened derivation is used at this level.


/// Account
/// This level splits the key space into independent user identities, so the wallet never mixes the coins across different accounts.
/// Users can use these accounts to organize the funds in the same fashion as bank accounts; for donation purposes (where all addresses are considered public), for saving purposes, for common expenses etc.
/// Accounts are numbered from index 0 in sequentially increasing manner. This number is used as child index in BIP32 derivation.
/// Hardened derivation is used at this level.
///Software should prevent a creation of an account if a previous account does not have a transaction history (meaning none of its addresses have been used before).
/// Software needs to discover all used accounts after importing the seed from an external source.


/// Change
/// Constant 0 is used for external chain and constant 1 for internal chain (also known as change addresses). External chain is used for addresses that are meant to be visible outside of the wallet (e.g. for receiving payments). Internal chain is used for addresses which are not meant to be visible outside of the wallet and is used for return transaction change.
/// Public derivation is used at this level.


/// Index
/// Addresses are numbered from index 0 in sequentially increasing manner. This number is used as child index in BIP32 derivation.
/// Public derivation is used at this level.



/// Account discovery
/// When the master seed is imported from an external source the software should start to discover the accounts in the following manner:
///     - derive the first account's node (index = 0)
///     - derive the external chain node of this account
///     - scan addresses of the external chain; respect the gap limit described below
///     - if no transactions are found on the external chain, stop discovery
///     - if there are some transactions, increase the account index and go to step 1
/// This algorithm is successful because software should disallow creation of new accounts if previous one has no transaction history, as described in chapter "Account" above.
/// Please note that the algorithm works with the transaction history, not account balances, so you can have an account with 0 total coins and the algorithm will still continue with discovery.


/// Address gap limit
/// Address gap limit is currently set to 20. If the software hits 20 unused addresses in a row, it expects there are no used addresses beyond this point and stops searching the address chain. We scan just the external chains, because internal chains receive only coins that come from the associated external chains.
/// Wallet software should warn when the user is trying to exceed the gap limit on an external chain by generating a new address.


/// https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki




/// BIP44
public struct BIP44 {
    /// Purpose，常量，固定值为44
    public static let purpose: String = "44"
}
