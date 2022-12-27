from brownie import accounts, network, chain, web3, Atk_Telephone, Telephone


def main():
    # 0x833514593c7798551A20Ac69f98D486e2A12dFe8
    accounts.add("0x3662a22892fc295c76adb33fc89ee7c8e1cdf769d7e059d28d0bed0d659eeaf9")
    wallet = accounts[-1]
    # accounts.default = wallet

    # telephone
    Telephone.at("0xc0021CfF9Dba227b182608532E4d93a2810f9fdd")
    tele = Telephone[-1]
    Atk_Telephone.deploy(tele, {"from": accounts[0]})
    atk = Atk_Telephone[-1]
    atk.atk({"from": wallet, "gas_limit": 1000000})
