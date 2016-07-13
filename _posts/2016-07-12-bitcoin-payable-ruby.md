---
layout:     post
title:      Working with Bitcoin in Ruby
author:     jon
date:       2016-07-12
published:  true
social_image: blog_posts/legaltech.jpg
description: A Ruby developer's journey into Bitcoin
---

Bitcoin can seem like a complicated technology that is always at the center of one debate or another.
I was interested in learning to work with Bitcoin and as an experienced developer I was curious as to what kind of barrier I would face as a beginner in the Bitcoin space.

<!--more-->

I am pleased to say that working with Bitcoin was much easier than expected and recommend that others give it a try as well.
The public nature of Bitcoin makes accessing payment data trivial, and you might find that you are able to build really interesting things without in depth Bitcoin knowledge.

### Building a payment system

I wanted to build a payment acceptance system that didn't use a third party provider.
This system would have a way for users to pay, monitor payments and take an action as a result of a completed payment.
The price of Bitcoin fluctuates constantly, so I also wanted the amount owed in Bitcoin to be stable.
I didn't want someone to be required to pay `0.001` BTC (a unit of bitcoin) and then have them owe me `0.01` 5 minutes later.  So I opted to **lock in** amounts owed for 30 minutes at a time.

Requirements:

1. Issue addresses to receive payments
2. Monitor addresses for payments
3. Lock payment amounts

### Bitcoin Payable

The result of my efforts is an open source Ruby gem called [bitcoin_payable](https://github.com/Sailias/bitcoin_payable).
This is a payment gem that is added to `ActiveRecord` models and allows a system to easily accept payments in Bitcoin.

Now, let's take a quick look at how I solved each of the requirements I listed above.

#### 1. Issue addresses to receive payments

This is the most technical aspect of the payment system.
In order to generate addresses for each payment required, I used a gem called [money-tree](https://github.com/GemHQ/money-tree) that uses [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki).
BIP32 creates addresses derived from a deterministic seed, and can be used to only create public addresses.
This means that a developer can create a `Master Public Key` using a Bitcoin wallet, add it as a configuration option when setting up `bitcoin_payable`, and the system will be able to generate an infinite number of public Bitcoin addresses.

#### 2. Monitor addressess for payments

This is actually the easiest part of building our payment system.  The Bitcoin blockchain is a public ledger and we can download it ourselves, index it and determine if a payment was made to our address.
An easier way is to use an existing RESTFUL API to query for payments made to your addresses.  If you notice that payments have been made to your address, you can sum them up, and determine if the payment is complete.

I was really blown away with how easy it was to do these two parts.  With very little effort, I can create addresses for people to make payments to, and monitor those addresses for the sucessful payments.

#### 3: Lock payment amounts 

This part was really just to make the payment system well rounded and user friendly.
I wrote a script that connects to [bitcoinaverage.com](https://api.bitcoinaverage.com), and stores the `24 hour weighted average` for your local currency (which you specify as a config option).
All payments that haven't been updated in 30 minutes that still require payment will have their amounts owed recalculated using the latest currency conversion, and then updated.

This only happens to payments that are still pending and haven't gotten a new price in 30 minutes, thus locking prices long enough for a payment to be made.

### Outro

I was able to use my programming experience to build a Bitcoin payment processing library that was functional, easy to integrate, and has security built into it (BIP32 public keys only!).
I did end up learning a lot about Bitcoin, but the existence of public APIs to query the blockchain and a number of existing libraries made it much easier than I originally anticipated.

