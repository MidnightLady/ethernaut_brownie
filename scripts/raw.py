from brownie import config, accounts, network, chain, web3, CoinFlip, atk_coinflip

from eth_account.datastructures import SignedTransaction
from web3 import Web3
from hexbytes import HexBytes
import rlp.sedes.serializable
from scripts.config import *


# ('chainId', 'nonce', 'maxPriorityFeePerGas', 'maxFeePerGas', 'gas', 'to', 'value', 'data', 'accessList')

def main():
    tx = {
        # 'chainId':1337,
        'nonce': web3.eth.get_transaction_count(wallet.address),
        'to': accounts[0].address,
        'value': web3.toWei(100, 'gwei'),
        'data': '0x1234abcd',
        'gas': 2000000,
        'gasPrice': web3.eth.gas_price,
    }
    print(tx)
    signed_tx: SignedTransaction = web3.eth.account.sign_transaction(tx, private_key=private_key)
    print(signed_tx)
    tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)
    print(tx_hash.hex())
    raw = web3.eth.get_transaction(tx_hash.hex())
    print(raw)

