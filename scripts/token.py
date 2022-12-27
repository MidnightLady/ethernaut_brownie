from brownie import *


def main():
    accounts.add("0x3662a22892fc295c76adb33fc89ee7c8e1cdf769d7e059d28d0bed0d659eeaf9")
    wallet = accounts[0]
    accounts.add()
    receiver = accounts[1]

    accounts.default = wallet
    Token.at("0x7302fBb20463fd99a13a4A551aCCf0E75CD20733")
    token = Token[0]

    token.transfer(receiver.address,21,{"from":wallet})
    print(token.balanceOf(wallet))
